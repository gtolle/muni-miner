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
      t.integer :psgr_on
      t.integer :psgr_off
      t.integer :psgr_load
      t.decimal :dwell_tot_mins, :precision => 10, :scale => 4
      t.datetime :act_stop_time
      t.datetime :act_dep_time
      t.datetime :sch_time
      t.decimal :dep_dev_mins, :precision => 10, :scale => 4
    end
    add_index( :stops, [ :route, :direction, :trip_date, :trip, :stop_seq_id ], :unique => true, :name => :stop_primary )
  end
end
