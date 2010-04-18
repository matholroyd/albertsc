class CreateRostersAndRelated < ActiveRecord::Migration
  def self.up
    create_table :rosters do |t|
      t.string :description
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
    
    create_table :roster_slots do |t|
      t.integer :roster_day_id
      t.integer :member_id
    end
    
    add_index :roster_slots, [:roster_day_id, :member_id]
    
    change_table :members do |t|
      t.boolean :qualified_for_ood, :default => false
      t.integer :chance_of_doing_duty, :default => 100
    end
  end

  def self.down
    change_table :members do |t|
      t.remove :qualified_for_ood
      t.remove :chance_of_doing_duty
    end

    drop_table :roster_slots
    drop_table :roster_days
    drop_table :rosters
  end
end
