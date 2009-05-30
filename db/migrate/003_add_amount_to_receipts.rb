class AddAmountToReceipts < ActiveRecord::Migration
  def self.up
    change_table :receipts do |t|
      t.string :amount
    end
  end

  def self.down
    change_table :receipts do |t|
      t.remove :amount
    end
  end
end
