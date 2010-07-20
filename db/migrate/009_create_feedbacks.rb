class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.text :what_is_the_reason_for_leaving
      t.text :what_did_you_like_most
      t.text :what_do_you_suggest_should_change
      t.text :any_other_tips_for_the_club
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
