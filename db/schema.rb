# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "asset_types", :force => true do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "invoiceable"
    t.integer "invoice_fee"
  end

  add_index "asset_types", ["position"], :name => "index_asset_types_on_position"

  create_table "assets", :force => true do |t|
    t.integer  "member_id"
    t.integer  "asset_type_id"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["asset_type_id", "member_id"], :name => "index_assets_on_asset_type_id_and_member_id"
  add_index "assets", ["asset_type_id", "member_id"], :name => "index_assets_on_member_id_and_asset_type_id"

  create_table "members", :force => true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "preferred_name"
    t.string   "name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "suburb"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
    t.integer  "membership_type_id"
    t.date     "date_of_birth"
    t.date     "joined_on"
    t.string   "email"
    t.string   "spouse_name"
    t.string   "phone_home"
    t.string   "phone_work"
    t.string   "phone_mobile"
    t.string   "emergency_contact_name_and_number"
    t.string   "occupation"
    t.string   "special_skills"
    t.string   "sex"
    t.boolean  "powerboat_licence",                 :default => false
    t.string   "status"
    t.integer  "associated_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "current_payment_expires_on"
    t.boolean  "qualified_for_ood",                 :default => false
    t.integer  "chance_of_doing_duty",              :default => 100
  end

  add_index "members", ["associated_member_id", "name", "status"], :name => "index_members_on_status_and_associated_member_id_and_name"
  add_index "members", ["associated_member_id", "name"], :name => "index_members_on_associated_member_id_and_name"
  add_index "members", ["name", "status"], :name => "index_members_on_status_and_name"
  add_index "members", ["name"], :name => "index_members_on_name"

  create_table "paypal_emails", :force => true do |t|
    t.text     "source"
    t.integer  "member_id"
    t.string   "message_id"
    t.boolean  "transfered_money_out_of_paypal"
    t.boolean  "recorded_in_accounting_package"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paypal_emails", ["created_at", "recorded_in_accounting_package", "transfered_money_out_of_paypal"], :name => "index_paypal_emails_on_transfered_money_out_of_paypal_and_recor"
  add_index "paypal_emails", ["member_id"], :name => "index_paypal_emails_on_member_id"
  add_index "paypal_emails", ["message_id"], :name => "index_paypal_emails_on_message_id"

  create_table "receipts", :force => true do |t|
    t.integer  "member_id"
    t.date     "payment_expires_on"
    t.string   "receipt_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amount"
    t.integer  "paypal_email_id"
  end

  add_index "receipts", ["member_id"], :name => "index_receipts_on_member_id"

  create_table "roster_days", :force => true do |t|
    t.integer "roster_id"
    t.date    "date"
    t.string  "description"
  end

  add_index "roster_days", ["roster_id", "date"], :name => "index_roster_days_on_roster_id_and_date"

  create_table "roster_slots", :force => true do |t|
    t.integer "roster_day_id"
    t.integer "member_id"
    t.boolean "require_qualified_for_ood", :default => false
    t.boolean "require_powerboat_licence", :default => false
  end

  add_index "roster_slots", ["roster_day_id", "member_id"], :name => "index_roster_slots_on_roster_day_id_and_member_id"

  create_table "rosters", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",          :limit => 30
    t.string   "last_name",           :limit => 30
    t.string   "email",                                            :null => false
    t.string   "crypted_password",                                 :null => false
    t.string   "password_salt",                                    :null => false
    t.string   "persistence_token",                                :null => false
    t.string   "single_access_token",                              :null => false
    t.string   "perishable_token",                                 :null => false
    t.integer  "login_count",                       :default => 0, :null => false
    t.integer  "failed_login_count",                :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
