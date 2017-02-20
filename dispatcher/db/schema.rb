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

ActiveRecord::Schema.define(version: 20_170_205_103_225) do
  create_table 'working_items', force: :cascade do |t|
    t.string   'work_type'
    t.string   'content'
    t.integer  'version'
    t.integer  'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w(work_type content version), name: 'index_working_items_on_working_type_and_content_and_version', unique: true
  end
end
