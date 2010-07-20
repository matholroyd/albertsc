class Feedback < ActiveRecord::Base
  def validate
    all_blank = [what_is_the_reason_for_leaving, what_did_you_like_most, what_do_you_suggest_should_change,
    any_other_tips_for_the_club].all? {|field| field.blank?}
    errors.add_to_base('Need to fill out at least one field') if all_blank
  end
end
