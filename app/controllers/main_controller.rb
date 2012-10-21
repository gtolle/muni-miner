class MainController < ApplicationController
  def index
  end

  def home

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
    trips = c.select_all "SELECT trip_date, trip, count(stop_seq_id) as stops FROM stops WHERE route = #{c.quote(params[:route])} AND direction = #{c.quote(params[:direction])} GROUP BY trip_date, trip ORDER BY trip_date, trip"
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

    Stop.interpolate_values( stops, "dep_dev_mins" )
    Stop.print_values( stops, "dep_dev_mins" )
    Stop.invert_values( stops, "dep_dev_mins" )
    #Stop.convert_to_deltas( stops, "dep_dev_mins" )

    stops.each do |stop|
      puts "%30s%30s%30s%30s" % [ stop.stop_name, stop.sch_time, stop.act_dep_time, stop.dep_dev_mins ]
    end
    
    # Stop.convert_to_deltas( stops, "dep_dev_mins" )
    respond_to do |format|
      format.json {
        render :json => stops.to_json
      }
    end
  end

end
