# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150615122053) do

  create_table "attachments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.integer  "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cities", :force => true do |t|
    t.integer  "state_id"
    t.string   "name",            :limit => 30
    t.string   "phone_area_code", :limit => 10
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "countries", :force => true do |t|
    t.string   "name",       :limit => 30
    t.string   "phone_code", :limit => 5
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "material_attachments", :force => true do |t|
    t.integer  "material_id"
    t.integer  "attachment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "material_attachments", ["attachment_id"], :name => "index_material_attachments_on_attachment_id"
  add_index "material_attachments", ["material_id"], :name => "index_material_attachments_on_material_id"

  create_table "material_media", :force => true do |t|
    t.integer  "media_id"
    t.integer  "material_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "material_media", ["material_id"], :name => "index_material_media_on_material_id"
  add_index "material_media", ["media_id"], :name => "index_material_media_on_media_id"

  create_table "material_media_types", :force => true do |t|
    t.integer  "material_id"
    t.integer  "media_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "material_media_types", ["material_id"], :name => "index_material_media_types_on_material_id"
  add_index "material_media_types", ["media_type_id"], :name => "index_material_media_types_on_media_type_id"

  create_table "material_watchers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "material_id"
    t.integer  "created_by_user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "material_watchers", ["material_id"], :name => "index_material_watchers_on_material_id"
  add_index "material_watchers", ["user_id"], :name => "index_material_watchers_on_user_id"

  create_table "materials", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "due_date"
  end

  create_table "media", :force => true do |t|
    t.string   "nombre",      :limit => 50
    t.string   "description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "media_media_types", :force => true do |t|
    t.integer  "media_id"
    t.integer  "media_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "media_media_types", ["media_id"], :name => "index_media_media_types_on_media_id"
  add_index "media_media_types", ["media_type_id"], :name => "index_media_media_types_on_media_type_id"

  create_table "media_types", :force => true do |t|
    t.string   "name",        :limit => 50
    t.string   "description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "city_id"
    t.string   "first_name",         :limit => 30
    t.string   "last_name",          :limit => 30
    t.string   "address",            :limit => 100
    t.string   "zip",                :limit => 10
    t.date     "birth_date"
    t.string   "phone",              :limit => 20
    t.string   "mobile",             :limit => 20
    t.string   "gender",             :limit => 1
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "profiles", ["city_id"], :name => "index_profiles_on_city_id"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sent_materials", :force => true do |t|
    t.integer  "user_id"
    t.integer  "material_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sent_materials", ["material_id"], :name => "index_sent_materials_on_material_id"
  add_index "sent_materials", ["user_id"], :name => "index_sent_materials_on_user_id"

  create_table "states", :force => true do |t|
    t.integer  "country_id"
    t.string   "name",       :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "states", ["country_id"], :name => "index_states_on_country_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,    :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0,    :null => false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "is_active",              :default => true
    t.integer  "media_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
