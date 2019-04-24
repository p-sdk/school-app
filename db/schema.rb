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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190417195851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "teacher_id"
    t.integer  "category_id"
    t.index ["category_id"], name: "index_courses_on_category_id", using: :btree
    t.index ["teacher_id"], name: "index_courses_on_teacher_id", using: :btree
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer  "student_id", null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id", using: :btree
    t.index ["student_id", "course_id"], name: "index_enrollments_on_student_id_and_course_id", unique: true, using: :btree
    t.index ["student_id"], name: "index_enrollments_on_student_id", using: :btree
  end

  create_table "lectures", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "course_id",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["course_id"], name: "index_lectures_on_course_id", using: :btree
  end

  create_table "solutions", force: :cascade do |t|
    t.integer  "enrollment_id", null: false
    t.integer  "task_id",       null: false
    t.text     "content"
    t.integer  "earned_points"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["enrollment_id", "task_id"], name: "index_solutions_on_enrollment_id_and_task_id", unique: true, using: :btree
    t.index ["enrollment_id"], name: "index_solutions_on_enrollment_id", using: :btree
    t.index ["task_id"], name: "index_solutions_on_task_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "desc"
    t.integer  "points"
    t.integer  "course_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_tasks_on_course_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.datetime "upgrade_request_sent_at"
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role",                    default: 0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "courses", "categories"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users", column: "student_id"
  add_foreign_key "lectures", "courses"
  add_foreign_key "solutions", "enrollments"
  add_foreign_key "solutions", "tasks"
  add_foreign_key "tasks", "courses"
end
