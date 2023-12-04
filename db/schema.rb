# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_03_180427) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessories", force: :cascade do |t|
    t.string "name"
    t.bigint "bicycle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bicycle_id"], name: "index_accessories_on_bicycle_id"
  end

  create_table "bicycles", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "model"
    t.integer "bicycle_type"
    t.integer "size"
    t.string "condition"
    t.integer "price_per_hour"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_bicycles_on_owner_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.bigint "bicycle_id"
    t.bigint "renter_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "rental_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bicycle_id"], name: "index_rentals_on_bicycle_id"
    t.index ["renter_id"], name: "index_rentals_on_renter_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "rental_id", null: false
    t.bigint "reviewed_user_id"
    t.bigint "reviewer_user_id"
    t.integer "rating"
    t.text "review_text"
    t.datetime "review_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_reviews_on_rental_id"
    t.index ["reviewed_user_id"], name: "index_reviews_on_reviewed_user_id"
    t.index ["reviewer_user_id"], name: "index_reviews_on_reviewer_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bicycles", "users", column: "owner_id"
  add_foreign_key "rentals", "users", column: "renter_id"
  add_foreign_key "reviews", "users", column: "reviewed_user_id"
  add_foreign_key "reviews", "users", column: "reviewer_user_id"
end
