class AddFinancialDetailsToMembers < ActiveRecord::Migration
  def self.up
    change_table :members do |t|
      t.boolean :financial
      t.date :current_payment_expires_on
    end
  end

  def self.down
    change_table :members do |t|
      t.remove :financial
      t.remove :current_payment_expires_on
    end
  end
end
