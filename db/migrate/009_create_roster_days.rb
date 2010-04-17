class CreateRosterDays < ActiveRecord::Migration
  def self.up
    create_table :roster_days do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :roster_days
  end
end
