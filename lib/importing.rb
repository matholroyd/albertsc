class Importing
  def self.import_members_from_file(file)
    Member.destroy_all
    Asset.destroy_all
    
    xmldoc = Hpricot.XML(file)

    add_members(xmldoc/'ClubData/Members/Member')
    add_members(xmldoc/'ClubData/ResignedMembers/Member', :status_transition => 'resign!')
    
  end
  
  def self.update_receipts_from_file(file)
    xmldoc = Hpricot.XML(file)

    add_receipts(xmldoc/'ClubData/*/Member')
  end
  
  def self.add_receipts(xpath)
    no_matches = []
    
    xpath.each do |member|
      first_name = (member/'Name/FirstName').first.inner_html
      last_name = (member/'Name/Surname').first.inner_html
      preferred_name = (member/'Name/PreferredName').first.inner_html
      title = (member/'Name/Title').first.inner_html
      street1 = (member/'Address/Street').first.inner_html
      

      puts "Finding matches for #{title} #{first_name} #{last_name} of #{street1}..."
      
      matches = Member.find(:all, :conditions => {:first_name => first_name, :last_name => last_name, 
        :preferred_name => preferred_name, :title => title, :street_address_1 => street1})

      matches.each do |match|
        puts " Found #{match.title} #{match.first_name} #{match.last_name} of #{match.street_address_1}..."
      end

      case matches.length
      when 0
        no_matches << {:first_name => first_name, :last_name => last_name, :preferred_name => preferred_name, 
          :title => title, :street1 => street1}
      when 1
        m = matches.first

        (member/'financialDetails/PreviousPayments/anyType').each do |receipt_node|
          receipt_number = (receipt_node/'ReceiptNumber').first.inner_html
          receipt_number = 'n/a' if receipt_number.blank?
          payment_expires_on = (receipt_node/'PaidUntil').first.inner_html
          
          m.receipts.create! :receipt_number => receipt_number, :payment_expires_on => payment_expires_on, 
          :amount => "n/a"
        end

        # Force a revalidation so that the financial status info is updated (note: calling valid? won't force this)
        m.save!
        
      else
        DBC.assert(matches.length == 1, "!! Multiple matches for first => #{first_name}, last => #{last_name} !!")
      end
      
    end
    
    if no_matches.length > 0
      puts "!! Found no matches in the DB for the following entries !!"
      no_matches.each do |no_match|
        puts " #{no_match[:title]} #{no_match[:first_name]} #{no_match[:last_name]} of #{no_match[:street1]}"
      end
    end
  end
    
  def self.add_members(xpath, options = {})
    xpath.each do |member|
      m = Member.new

      m.first_name = (member/'Name/FirstName').first.inner_html
      m.last_name = (member/'Name/Surname').first.inner_html
      m.preferred_name = (member/'Name/PreferredName').first.inner_html
      m.title = (member/'Name/Title').first.inner_html

      # next if Member.exists?(:first_name => m.first_name, :last_name => m.last_name, :preferred_name => m.preferred_name) 

      m.street_address_1 = (member/'Address/Street').first.inner_html
      m.street_address_2 = (member/'Address/Street2').first.inner_html
      m.suburb = (member/'Address/Suburb').first.inner_html
      m.state = (member/'Address/State').first.inner_html
      m.postcode = (member/'Address/Postcode').first.inner_html
      m.country = (member/'Address/Country').first.inner_html

      m.membership_type = MembershipType.find_by_name((member/'MembershipDetails/MembershipType/MembershipTypeName').first.inner_html)
      m.joined_on = (member/'MembershipDetails/DateJoined').first.inner_html
      m.date_of_birth = (member/'MembershipDetails/Dob').first.inner_html

      if m.valid?
        m.save
      else
        next
      end
      
      m.emergency_contact_name_and_number = ''
      m.special_skills = ''
      m.occupation = ''

      (member/'MemberInformation/MemberInformation').each do |member_info|
        key = (member_info/'InformationKey').first.inner_html.strip
        value = (member_info/'InformationValue').first.inner_html.strip

        case key.downcase
        when 'home telephone'
          m.phone_home = value
        when 'business telephone'
          m.phone_work = value
        when 'occupation', 'profession', 'engineer'
          m.occupation += value
        when 'sex'
          m.sex = value
        when 'power boat license'
          m.powerboat_licence = (value.downcase == 'yes')

        when /skills/
          m.special_skills += value
        when /spouse/
          m.spouse_name = value
        when /mobile/
          m.phone_mobile = value
        when /emergency/
          m.emergency_contact_name_and_number += value
        when /email/
          m.email = value
        when /ayf number/
          m.assets.create :details => value, :asset_type => AssetType.find_by_name('Yv/Ya Membership Number') unless value.blank?
        when /registered boat/
          m.assets.create :details => value, :asset_type => AssetType.find_by_name('Boat') unless value.blank?
        when /key/
          m.assets.create :details => value, :asset_type => AssetType.find_by_name('Key') unless value.blank?
          
        when /father/, /mother/
          #do nothing
        else
          DBC.fail("unexpected information value #{key} => #{value}")
        end
      end

      (member/'AssetsCollection/Asset').each do |asset_node| 
        a = Asset.new
                
        type = (asset_node/'AssetType/AssetTypeName').first.inner_html.downcase
        
        case type
        when /bottom/
          a.asset_type = AssetType.find_by_name 'Rack Bottom'
        when /middle/
          a.asset_type = AssetType.find_by_name 'Rack Middle'
        when /top/
          a.asset_type = AssetType.find_by_name 'Rack Top'
        when /minnow/
          a.asset_type = AssetType.find_by_name 'Rack Minnow'
        else 
          DBC.fail("unexpected asset type #{type}")
        end
        
        a.details = (asset_node/'AssetName').first.inner_html
        a.member = m
        a.save!
      end

      (member/'ChildMembersCollection/ChildMember').each do |child|
        am = Member.new
        am.first_name = (child/'FirstName').first.inner_html
        am.last_name = (child/'Surname').first.inner_html
        am.date_of_birth = (child/'Dob').first.inner_html
        am.associated_member = m
        
        if am.valid?
          am.save!
          am.send(options[:status_transition]) if options[:status_transition]
        end
      end

      m.save!
      m.send(options[:status_transition]) if options[:status_transition]

      puts m.inspect
    end
  end
  
end