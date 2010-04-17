class CreateRostersAndRelated < ActiveRecord::Migration
  def self.up
    create_table :rosters do |t|
      t.date :start_on
      t.date :finish_on

      t.timestamps
    end
    
    create_table :roster_days do |t|
      t.integer :roster_id
      t.date :date
      t.string :description
      
      t.timestamps
    end
    
    add_index :roster_days, [:roster_id, :date]
  end

  def self.down
    drop_table :roster_days
    drop_table :rosters
  end
end
