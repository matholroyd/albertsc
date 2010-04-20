class CreateRostersAndRelated < ActiveRecord::Migration
  def self.up
    create_table :rosters do |t|
      t.string :description

      t.timestamps
    end
    
    create_table :roster_days do |t|
      t.integer :roster_id
      t.date :date
      t.string :description
    end
    
    add_index :roster_days, [:roster_id, :date]
    
    create_table :roster_slots do |t|
      t.integer :roster_day_id
      t.integer :member_id
      t.boolean :require_qualified_for_ood, :default => false
      t.boolean :require_powerboat_licence, :default => false
    end
    
    add_index :roster_slots, [:roster_day_id, :member_id]
    
    change_table :members do |t|
      t.boolean :qualified_for_ood, :default => false
      t.integer :chance_of_doing_duty, :default => 100
    end

    change_column :members, :powerboat_licence, :boolean, :default => false
  end

  def self.down
    change_column :members, :powerboat_licence, :boolean
    
    change_table :members do |t|
      t.remove :qualified_for_ood
      t.remove :chance_of_doing_duty
    end

    drop_table :roster_slots
    drop_table :roster_days
    drop_table :rosters
  end
end
