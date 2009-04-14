class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :title, :limit => 5
      t.string :first_name, :last_name, :preferred_name, :limit => 30
      
      t.string :street_address_1, :street_address_2
      t.string :suburb, :limit => 80
      t.string :state, :limit => 30 
      t.string :postcode, :limit => 15
      t.string :country, :limit => 50

      t.boolean :has_separate_mailing_address

      t.string :mailing_street_address_1, :mailing_street_address_2
      t.string :mailing_suburb, :limit => 80
      t.string :mailing_state, :limit => 30 
      t.string :mailing_postcode, :limit => 15
      t.string :mailing_country, :limit => 50
      
      t.string :membership_number
      t.integer :membership_type_id
      t.date :date_of_birth
      t.date :joined_on
      
      t.string :email
      t.string :phone_home, :phone_work, :phone_mobile, :limit => 25
      t.string :occupation
      t.string :special_skills
      t.string :sex, :limit => 1
      t.boolean :powerboat_licence
      
      t.string :state, :limit => 50
      
      t.timestamps
    end
    
    add_index :members, :state
    
    create_table :assets do |t|
      t.integer :member_id
      t.string :type, :limit => 40
      t.string :details
    end
    
    add_index :assets, [:type, :member_id]
    add_index :assets, [:member_id, :type]
  end

  def self.down
    drop_table :assets
    drop_table :members
  end
end
