require 'pg'

class Line

  attr_reader :name, :id

  def initialize(input_hash)
    @name = input_hash[:name]
    @id = input_hash[:id]
  end

  def self.create(coconut_banana)
    line = Line.new(coconut_banana)
    line.save
    line
  end

  def self.all
    results = DB.exec("SELECT * FROM lines;")
    lines = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      lines << Line.new({:name => name, :id => id})
    end
    lines
  end

  def save
    results = DB.exec("INSERT INTO lines(name) VALUES('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM lines WHERE id = #{@id};")
  end

  def edit_name(new_name)
    DB.exec("UPDATE lines SET name = '#{new_name}';")
    @name = new_name
  end

  def add_stop(station_id)
    DB.exec("INSERT INTO stops (station_id, line_id) VALUES (#{station_id}, #{@id});")
  end

  def delete_stop(station_id)
    DB.exec("DELETE FROM stops WHERE station_id = #{station_id};")
  end

  def find_stations
    results = DB.exec("SELECT * FROM stops WHERE line_id = #{@id};")
    stops = []
    results.each do |result|
      stops << result['station_id'].to_i
    end
    stations_on_this_line = []
    stops.each do |station|
      this_station = DB.exec("SELECT * FROM stations WHERE id = #{station};")
      name = this_station.first['name']
      id = this_station.first['id'].to_i
      stations_on_this_line << Station.new({:name => name, :id => id})
    end
    stations_on_this_line
  end

  def ==(another_line)
    self.name == another_line.name && self.id == another_line.id
  end

end
