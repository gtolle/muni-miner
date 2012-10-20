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

ActiveRecord::Schema.define(:version => 20121020162613) do

  create_table "stops", :force => true do |t|
    t.string   "route"
    t.integer  "direction"
    t.string   "pattern"
    t.integer  "day_of_wk"
    t.date     "trip_date"
    t.integer  "trip"
    t.integer  "stop_seq_id"
    t.integer  "stop_id"
    t.string   "stop_name"
    t.decimal  "latitude",       :precision => 20, :scale => 17
    t.decimal  "longitude",      :precision => 20, :scale => 17
    t.integer  "psgr_on"
    t.integer  "psgr_off"
    t.integer  "psgr_load"
    t.decimal  "dwell_tot_mins", :precision => 10, :scale => 4
    t.datetime "act_stop_time"
    t.datetime "act_dep_time"
    t.datetime "sch_time"
    t.decimal  "dep_dev_mins",   :precision => 10, :scale => 4
  end

  add_index "stops", ["route", "direction", "trip_date", "trip", "stop_seq_id"], :name => "stop_primary", :unique => true

end
