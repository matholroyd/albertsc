class AddPaypalEmails < ActiveRecord::Migration
  def self.up
    create_table :paypal_emails, :force => true do |t|
      t.text :source
      t.integer :member_id
      t.string :message_id
      t.boolean :transfered_money_out_of_paypal
      t.boolean :recorded_in_accounting_package
      t.timestamps
    end

    change_table :receipts do |t|
      t.integer :paypal_email_id
    end

    add_index :paypal_emails, [:message_id]
    add_index :paypal_emails, [:member_id]
    add_index :paypal_emails, [:transfered_money_out_of_paypal, :recorded_in_accounting_package, :created_at]
  end

  def self.down
    change_table :receipts do |t|
      t.remove :paypal_email_id
    end

    drop_table :paypal_emails
  end
end


