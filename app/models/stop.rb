class Stop < ActiveRecord::Base
  attr_accessible :act_dep_time, :act_stop_time, :day_of_wk, :dep_dev_mins, :direction, :dwell_tot_mins, :latitude, :longitude, :pattern, :psgr_load, :psgr_off, :psgr_on, :route, :sch_time, :stop_id, :stop_name, :stop_seq_id, :trip, :trip_date, :max_velocity, :val_full, :val_overcrowd, :rear_door_boardings, :act_move_time, :act_trip_run_miles, :act_miles_since_last_stop, :act_mins_since_last_stop, :psgr_miles, :psgr_hours, :door_cycles, :sch_dwell_mins, :sch_recovery_mins, :act_recovery_mins, :arr_dev_mins

  def self.get_routes
    c = ActiveRecord::Base.connection
    routes = c.select_all "SELECT route, direction FROM stops GROUP BY route, direction ORDER BY route, direction"
    return routes
  end

  def self.get_trips( route, direction )
    c = ActiveRecord::Base.connection
    trips = c.select_all "SELECT min(act_dep_time) as act_dep_time, trip_date, trip FROM stops WHERE route = #{c.quote(route)} AND direction = #{c.quote(direction)} AND stop_seq_id = 1 GROUP BY trip_date, trip ORDER BY trip_date, trip"
    return trips
  end

  def self.get_worst_stops( route, direction )
    c = ActiveRecord::Base.connection
    # worst_stops = c.select_all "select route, direction, stop_name, stop_id, min(latitude) as latitude, min(longitude) as longitude, avg(dep_dev_mins_diff) * (sum(psgr_on) + sum(psgr_off)) as delay_metric from stops where route = #{c.quote(route)} and direction = #{c.quote(direction)} group by route, direction, stop_name, stop_id order by delay_metric limit 5"
    worst_stops = c.select_all "select route, direction, stop_name, stop_id, min(latitude) as latitude, min(longitude) as longitude, avg(dep_dev_mins_diff) * sum(psgr_load) as delay_metric from stops where route = #{c.quote(route)} and direction = #{c.quote(direction)} group by route, direction, stop_name, stop_id order by delay_metric limit 5"
    # worst_stops = c.select_all "select route, direction, stop_name, stop_id, min(latitude) as latitude, min(longitude) as longitude, avg(dep_dev_mins_diff) as delay_metric from stops where route = #{c.quote(route)} and direction = #{c.quote(direction)} group by route, direction, stop_name, stop_id order by delay_metric limit 10"
    return worst_stops
  end

  def self.print_values( stops )
    stops.each do |stop|
      puts "%30s%30s%30s(%10s)(%10s)(%10s)(%10s)" % [ stop.stop_name, 
                                                      stop.sch_time, 
                                                      stop.act_dep_time, 
                                                      stop.dep_dev_mins, 
                                                      stop.dep_dev_mins_interp, 
                                                      stop.dep_dev_mins_diff, 
                                                      stop.psgr_on + stop.psgr_off ]
    end
  end

  def self.convert_to_deltas( stops, attr, destattr )
    last_val = nil
    stops.each do |stop|
      cur_val = stop[attr]
      if not last_val.nil?
        if not stop[attr].nil?
          stop[destattr] = stop[attr] - last_val
          last_val = cur_val
        end
      else
        last_val = stop[attr]
      end
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

  def self.copy_values( stops, attr, destattr )
    stops.each do |stop|
      stop[destattr] = stop[attr]
    end
  end

  def self.save_values( stops )
    stops.each do |stop|
      stop.save
    end
  end
end
