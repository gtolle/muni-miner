rowcount = 0
dropped_rows = 0

def parse_date( str )
  return nil if str.nil?
  date = nil
  begin
    date = DateTime.strptime(str, '%m/%d/%Y %I:%M:%S %p')
  rescue ArgumentError => e
    date = DateTime.strptime(str, '%m/%d/%Y')
  end      
end

CSV.foreach(ARGV[0], {:headers => true}) do |row|
  next if row["STOP_ID"] == "9999"
  next if row["ROUTE"] == "0"
  
  begin
    puts row
    stop = Stop.new
    params = {}
    stop.attributes.each do |name, val|
      next if name == "id"
      params[name.downcase.to_sym] = row[name.upcase]
    end

    # pp params

    params[:trip_date] = DateTime.strptime( params[:trip_date], '%m/%d/%Y' )

    params[:act_move_time] = parse_date( params[:act_move_time] )
    params[:act_stop_time] = parse_date( params[:act_stop_time] )
    params[:act_dep_time] = parse_date( params[:act_dep_time] )

    params[:sch_time] = parse_date( params[:sch_time] )
    stop.update_attributes(params)
    stop.save
  rescue ActiveRecord::RecordNotUnique => e
    dropped_rows += 1
    if dropped_rows % 100 == 0
      $stderr.puts "dropped rows = #{dropped_rows}"
    end
    next
  end    
  rowcount += 1
  if rowcount % 10000 == 0
    $stderr.puts rowcount
  end
end

puts "rowcount = #{rowcount}"
puts "dropped_rows = #{dropped_rows}"
