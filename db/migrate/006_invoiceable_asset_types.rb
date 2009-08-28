class InvoiceableAssetTypes < ActiveRecord::Migration
  def self.up
    change_table :asset_types do |t|
      t.boolean :invoiceable
      t.integer :invoice_fee
    end
    
    AssetType.all.each do |at|
      at.invoiceable = at.name.include?('Rack')
      at.invoice_fee = -99 if at.invoiceable?
      at.save!
    end
  end
  
  def self.down
    change_table :asset_types do |t|
      t.remove :invoiceable
      t.remove :invoice_fee
    end
  end
end
