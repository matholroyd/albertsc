class Importing
  def self.import_from_file(file)
    Member.destroy_all
    Asset.destroy_all
    
    xmldoc = Hpricot.XML(file)

    add_members(xmldoc/'ClubData/Members/Member')
    add_members(xmldoc/'ClubData/ResignedMembers/Member', :status_transition => 'resign!')
    
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

      (member/'MemberInformation/MemberInformation').each do |member_info|
        key = (member_info/'InformationKey').first.inner_html.strip
        value = (member_info/'InformationValue').first.inner_html.strip

        case key.downcase
        when 'special skills'
          m.special_skills = value
        when 'spouse name'
          m.spouse_name = value
        when 'home telephone'
          m.phone_home = value
        when 'business telephone'
          m.phone_work = value
        when 'mobile telephone'
          m.phone_mobile = value
        when 'emergency contact'
          m.emergency_contact_name_and_number = value
        when 'occupation'
          m.occupation = value
        when 'email address'
          m.email = value
        when 'sex'
          m.sex = value

        when 'power boat license'
          m.powerboat_licence = value.downcase == 'yes'

        when 'registered boat'
          m.assets.create :details => value, :asset_type => AssetType::Boat unless value.blank?
        when 'club key &amp; card number'
          m.assets.create :details => value, :asset_type => AssetType::ClubKey unless value.blank?
        end
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