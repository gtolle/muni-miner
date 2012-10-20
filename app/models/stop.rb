class Stop < ActiveRecord::Base
  attr_accessible :act_dep_time, :act_stop_time, :day_of_wk, :dep_dev_mins, :direction, :dwell_tot_mins, :latitude, :longitude, :pattern, :psgr_load, :psgr_off, :psgr_on, :route, :sch_time, :stop_id, :stop_name, :stop_seq_id, :trip, :trip_date
end
