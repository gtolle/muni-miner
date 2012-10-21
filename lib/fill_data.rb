routes = Stop.get_routes
routes.each do |route|
  pp route
  trips = Stop.get_trips(route["route"], route["direction"])
  trips.each do |trip|
    pp trip
    stops = Stop.where(:route => route["route"], :direction => route["direction"], :trip_date => trip["trip_date"], :trip => trip["trip"]).order('stop_seq_id asc')
    Stop.print_values( stops )
    Stop.convert_to_deltas( stops, "dep_dev_mins", "dep_dev_mins_diff" )
    Stop.copy_values( stops, "dep_dev_mins", "dep_dev_mins_interp" )
    Stop.interpolate_values( stops, "dep_dev_mins_interp" )
    Stop.interpolate_values( stops, "dep_dev_mins_diff" )
    Stop.invert_values( stops, "dep_dev_mins_interp" )
    Stop.invert_values( stops, "dep_dev_mins_diff" )
    puts "-------------"
    Stop.print_values( stops )
    Stop.save_values( stops )
  end
end
