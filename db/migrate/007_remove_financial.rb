class RemoveFinancial < ActiveRecord::Migration
  def self.up
    remove_column :members, :financial
  end

  def self.down
    add_column :members, :financial, :boolean
  end
end
