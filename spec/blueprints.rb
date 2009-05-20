require 'faker'

Sham.name     { Faker::Name.name }
Sham.email    { Faker::Internet.email }
Sham.title    { Faker::Lorem.sentence }
Sham.text     { Faker::Lorem.paragraph }
Sham.login    { Faker::Internet.user_name }
Sham.word     { Faker::Lorem.words(1).first }
Sham.details  { Faker::Lorem.words(3) }
Sham.password(:unique => false) { 'secret' }

Member.blueprint do
  preferred_name { Sham.name }
  email
end

Asset.blueprint do
  member
  details
  asset_type_id { AssetType::Boat.id }
end

User.blueprint do
  first_name { Sham.name }
  last_name { Sham.name }
  email { Sham.email }
  password { Sham.password }
  password_confirmation { password }
end
