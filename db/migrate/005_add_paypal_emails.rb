class AddPaypalEmails < ActiveRecord::Migration
  def self.up
    create_table :paypal_emails, :force => true do |t|
      t.text :source
      t.integer :member_id
      t.boolean :processed 
      t.string :message_id
      t.timestamps
    end

    add_index :paypal_emails, [:message_id]
    add_index :paypal_emails, [:member_id]
    add_index :paypal_emails, [:processed, :created_at]
  end
  

  def self.down
    drop_table :paypal_emails
  end
end


