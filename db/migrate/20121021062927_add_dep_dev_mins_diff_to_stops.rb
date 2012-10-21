class AddDepDevMinsDiffToStops < ActiveRecord::Migration
  def change
    add_column :stops, :dep_dev_mins_interp, :decimal, :precision => 10, :scale => 4
    add_column :stops, :dep_dev_mins_diff, :decimal, :precision => 10, :scale => 4
  end
end
