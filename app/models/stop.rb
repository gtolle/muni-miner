class Stop < ActiveRecord::Base
  attr_accessible :act_dep_time, :act_stop_time, :day_of_wk, :dep_dev_mins, :direction, :dwell_tot_mins, :latitude, :longitude, :pattern, :psgr_load, :psgr_off, :psgr_on, :route, :sch_time, :stop_id, :stop_name, :stop_seq_id, :trip, :trip_date, :max_velocity, :val_full, :val_overcrowd, :rear_door_boardings, :act_move_time, :act_trip_run_miles, :act_miles_since_last_stop, :act_mins_since_last_stop, :psgr_miles, :psgr_hours, :door_cycles, :sch_dwell_mins, :sch_recovery_mins, :act_recovery_mins, :arr_dev_mins

  def self.print_values( stops, attr )
    stops.each do |stop|
      puts "%30s%30s" % [ stop.stop_name, stop[attr] ]
    end
  end

  def self.interpolate_values( stops, attr )
    last_val = nil
    attr = attr.to_sym

    stops.reverse.each do |stop|
      if stop[attr].nil?
        stop[attr] = last_val
      else
        last_val = stop[attr]
      end
    end
  end

  def self.invert_values( stops, attr )
    stops.each do |stop|
      next if stop[attr].nil?
      stop[attr] = -stop[attr]
    end
  end

  def self.floor_values( stops, attr )
    stops.each do |stop|
      if stop[attr] < 0
        stop[attr] = 0
      end
    end
  end

  def self.convert_to_deltas( stops, attr )
    last_val = nil
    stops.each do |stop|
      cur_val = stop[attr]
      if not last_val.nil?
        if not stop[attr].nil?
          stop[attr] = stop[attr] - last_val
          last_val = cur_val
        end
      else
        last_val = stop[attr]
      end
    end
  end

end
