class MainController < ApplicationController
  def index
  end

  def route
    stops = Stop.where(:route => params[:route], :direction => params[:direction], :trip_date => params[:trip_date], :trip => params[:trip]).order('stop_seq_id asc')
    respond_to do |format|
      format.json {
        render :json => stops.to_json
      }
    end
  end
end
