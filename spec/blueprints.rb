require 'faker'
require 'machinist/active_record'
require 'sham'

Sham.name     { Faker::Name.name }
Sham.email    { Faker::Internet.email }
Sham.title    { Faker::Lorem.sentence }
Sham.text     { Faker::Lorem.paragraph }
Sham.login    { Faker::Internet.user_name }
Sham.word     { Faker::Lorem.words(1).first }
Sham.details  { Faker::Lorem.words(3) }
Sham.password(:unique => false) { 'secret' }

Member.blueprint do
  membership_type { MembershipType::Senior }
  preferred_name { Sham.name }
  email
end

AssetType.blueprint do
  name { Sham.word }
end

Asset.blueprint do
  member
  details
  asset_type
end

Receipt.blueprint do
  amount { Sham.word }
  member
  receipt_number { Sham.word }
  payment_expires_on { 1.day.ago.to_date }
end

User.blueprint do
  first_name { Sham.name }
  last_name { Sham.name }
  email { Sham.email }
  password { Sham.password }
  password_confirmation { password }
end

PaypalEmail.blueprint do
  source { File.read(RAILS_ROOT + '/spec/support/email_source/example_paypal_email.txt') }
end

Roster.blueprint do
end

RosterDay.blueprint do
  roster
  date { rand(1000).days.from_now.to_date }
end

RosterSlot.blueprint do
  roster_day
  member
end