class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :route
      t.integer :direction
      t.string :pattern
      t.integer :day_of_wk
      t.date :trip_date
      t.integer :trip
      t.integer :stop_seq_id

      t.integer :stop_id
      t.string :stop_name

      t.decimal :latitude, :precision => 20, :scale => 17
      t.decimal :longitude, :precision => 20, :scale => 17

      t.integer :max_velocity
      
      t.integer :psgr_on
      t.integer :psgr_off
      t.integer :psgr_load
      t.integer :val_full
      t.integer :val_overcrowd
      t.integer :rear_door_boardings

      t.datetime :act_stop_time
      t.datetime :act_move_time
      t.datetime :act_dep_time
      t.datetime :sch_time

      t.decimal :act_trip_run_miles, :precision => 10, :scale => 1
      t.decimal :act_miles_since_last_stop, :precision => 10, :scale => 2
      t.decimal :act_mins_since_last_stop, :precision => 10, :scale => 1

      t.decimal :psgr_miles, :precision => 10, :scale => 3
      t.decimal :psgr_hours, :precision => 10, :scale => 3

      t.integer :door_cycles

      t.decimal :dwell_tot_mins, :precision => 10, :scale => 4

      t.integer :sch_dwell_mins
      t.integer :sch_recovery_mins
      t.decimal :act_recovery_mins, :precision => 10, :scale => 2

      t.decimal :arr_dev_mins, :precision => 10, :scale => 4
      t.decimal :dep_dev_mins, :precision => 10, :scale => 4
    end
    add_index( :stops, [ :route, :direction, :trip_date, :trip, :stop_seq_id ], :unique => true, :name => :stop_primary )
  end
end
