require File.dirname(__FILE__) + '/../../config/boot'
require File.dirname(__FILE__) + '/../../config/environment'

def create_user(attributes)
  User.create!(attributes) unless User.exists?(:email => attributes[:email])
end

namespace :db do
  desc "Bootstraps the database"
  task :bootstrap do
    create_user(:email => 'me@home.com',
      :password               => 'secret',
      :password_confirmation  => 'secret'
    )    
  end
  
  task :import => [:environment] do
    Member.destroy_all
    
    xmldoc = Hpricot.XML(open('/Users/matholroyd/Desktop/DataArchive/export.xml'))

    (xmldoc/'ClubData/Members/Member').each do |member|
      m = Member.new
      
      m.first_name = (member/'Name/FirstName').first.inner_html
      m.last_name = (member/'Name/Surname').first.inner_html
      m.preferred_name = (member/'Name/FirstName').first.inner_html

      m.street_address_1 = (member/'Address/Street').first.inner_html
      m.street_address_2 = (member/'Address/Street2').first.inner_html
      m.suburb = (member/'Address/Suburb').first.inner_html
      m.state = (member/'Address/Postcode').first.inner_html
      m.postcode = (member/'Address/State').first.inner_html
      m.country = (member/'Address/Country').first.inner_html
            
      m.membership_type_id = (member/'MembershipDetails/MembershipType/MembershipTypeName').first.inner_html
      m.joined_on = (member/'MembershipDetails/DateJoined').first.inner_html
      m.date_of_birth = (member/'MembershipDetails/Dob').first.inner_html
      
      m.save!
      
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
            
      puts m.inspect
      m.save!

    end
    
  end
end


