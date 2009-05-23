class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :title
      t.string :first_name, :last_name, :preferred_name, :name
      
      t.string :street_address_1, :street_address_2
      t.string :suburb
      t.string :state
      t.string :postcode
      t.string :country
      
      t.integer :membership_type_id
      t.date :date_of_birth
      t.date :joined_on
      
      t.string :email
      t.string :spouse_name
      t.string :phone_home, :phone_work, :phone_mobile
      t.string :emergency_contact_name_and_number
      t.string :occupation
      t.string :special_skills
      t.string :sex
      t.boolean :powerboat_licence
            
      t.string :status
      t.integer :associated_member_id
      
      t.timestamps
    end
    add_index :members, [:status, :associated_member_id, :name]
    add_index :members, [:status, :name]
    add_index :members, [:associated_member_id, :name]
    add_index :members, [:name]
    
    create_table :assets do |t|
      t.integer :member_id
      t.integer :asset_type_id
      t.string :details

      t.timestamps
    end
    add_index :assets, [:asset_type_id, :member_id]
    add_index :assets, [:member_id, :asset_type_id]

    create_table :asset_types do |t|
      t.string :name
      t.integer :position
    end
    add_index :asset_types, [:position]
    
    create_table :receipts do |t|
      t.integer :member_id
      t.date :payment_expires_on
      t.string :receipt_number
      
      t.timestamps
    end
    add_index :receipts, [:member_id]
    
  end

  def self.down
    drop_table :receipts
    drop_table :asset_types
    drop_table :assets
    drop_table :members
  end
end
