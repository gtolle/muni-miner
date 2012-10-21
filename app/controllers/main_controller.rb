class MainController < ApplicationController
  def index
  end

  def routes
    c = ActiveRecord::Base.connection
    routes = c.select_all "SELECT route, direction FROM stops GROUP BY route, direction ORDER BY route, direction"
    respond_to do |format|
      format.json {
        render :json => routes.to_json
      }
    end
  end

  def trips
    c = ActiveRecord::Base.connection
    trips = c.select_all "SELECT min(act_dep_time) as act_dep_time, trip_date, trip FROM stops WHERE route = #{c.quote(params[:route])} AND direction = #{c.quote(params[:direction])} AND stop_seq_id = 1 GROUP BY trip_date, trip ORDER BY trip_date, trip"
    trips.each do |trip|
      trip["act_dep_time"] = trip["act_dep_time"].to_s(:nice)
      # trip["act_dep_time"] = Time.parse(trip["act_dep_time"]).to_s(:nice)
    end
    respond_to do |format|
      format.json {
        render :json => trips.to_json
      }
    end
  end

  def trip
    stops = Stop.where(:route => params[:route], :direction => params[:direction], :trip_date => params[:trip_date], :trip => params[:trip]).order('stop_seq_id asc')

    # don't use the last stop
    # stops.delete_at(stops.length-1)

    Stop.convert_to_deltas( stops, "dep_dev_mins" )
    Stop.interpolate_values( stops, "dep_dev_mins" )
    Stop.print_values( stops, "dep_dev_mins" )
    Stop.invert_values( stops, "dep_dev_mins" )

    stops.each do |stop|
      puts "%30s%30s%30s%30s%20s" % [ stop.stop_name, stop.sch_time, stop.act_dep_time, stop.dep_dev_mins, stop.psgr_on + stop.psgr_off ]
    end
    
    # Stop.convert_to_deltas( stops, "dep_dev_mins" )
    respond_to do |format|
      format.json {
        render :json => stops.to_json
      }
    end
  end

  def trips_by_day_and_time
    
    # get list of trips that actually start within the selected time

    "select sch_time, trip_date, trip from stops where route = 22 and direction = 0 and stop_seq_id = 1 and dayofweek(sch_time) = 4 and time(sch_time) >= '14:00' and time(sch_time) < '15:00' order by sch_time asc;"

    "select route, direction, trip_date, trip, stop_seq_id, stop_id, avg(dep_dev_mins) from stops where route = 22 and direction = 0 and trip in ( 1801, 1836 ) group by stop_seq_id;"
  end

end
