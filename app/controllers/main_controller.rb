class MainController < ApplicationController
  def index
  end

  def home

  end

  def routes
    routes = Stop.get_routes
    respond_to do |format|
      format.json {
        render :json => routes.to_json
      }
    end
  end

  def trips
    trips = Stop.get_trips( params[:route], params[:direction] )
    trips.each do |trip|
      if trip["act_dep_time"].is_a? String
        trip["act_dep_time"] = Time.parse(trip["act_dep_time"]).to_s(:nice)
      else
        trip["act_dep_time"] = trip["act_dep_time"].to_s(:nice)
      end
    end
    respond_to do |format|
      format.json {
        render :json => trips.to_json
      }
    end
  end

  def trip
    stops = Stop.where(:route => params[:route], :direction => params[:direction], :trip_date => params[:trip_date], :trip => params[:trip]).order('stop_seq_id asc')

    Stop.print_values( stops )

    respond_to do |format|
      format.json {
        render :json => stops.to_json
      }
    end
  end

  def worst_stops
    worst_stops = Stop.get_worst_stops(params[:route], params[:direction])
    respond_to do |format|
      format.json {
        render :json => worst_stops.to_json
      }
    end
  end

  def all_stops
    all_stops = Stop.get_all_stops(params[:route], params[:direction])
    respond_to do |format|
      format.json {
        render :json => all_stops.to_json
      }
    end
  end
 
  def trips_by_day_and_time
    
    # get list of trips that actually start within the selected time

    "select sch_time, trip_date, trip from stops where route = 22 and direction = 0 and stop_seq_id = 1 and dayofweek(sch_time) = 4 and time(sch_time) >= '14:00' and time(sch_time) < '15:00' order by sch_time asc;"

    "select route, direction, trip_date, trip, stop_seq_id, stop_id, avg(dep_dev_mins) from stops where route = 22 and direction = 0 and trip in ( 1801, 1836 ) group by stop_seq_id;"
  end

end
