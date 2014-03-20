require 'pg'
require 'pry'

class Station
  attr_reader :name, :id

  def initialize(input_hash)
    @name = input_hash[:name]
    @id = input_hash[:id]
  end

  def Station.create(input_hash)
     station = Station.new(input_hash)
     station.save
     station
  end

  def Station.all
    results = DB.exec("SELECT * FROM stations")
    stations = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      stations << Station.new({:name => name, :id => id})
    end
    stations
  end

  def save
    results = DB.exec("INSERT INTO stations (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM stations WHERE id = #{@id};")
  end

  def edit_name(new_name)
    DB.exec("UPDATE stations SET name = '#{new_name}';")
    @name = new_name
  end

  def find_lines
    results = DB.exec("SELECT * FROM stops WHERE station_id = #{@id};")
    stops = []
    results.each do |result|
      stops << result['line_id'].to_i
    end
    lines_through_this_station = []
    stops.each do |line|
      line_result = DB.exec("SELECT * FROM lines WHERE id = #{line};")
      name = line_result.first['name']
      id = line_result.first['id'].to_i
      lines_through_this_station << Line.new({:name => name, :id => id})
    end
    lines_through_this_station
  end
end



