require 'spec_help'

describe Line do
  describe '.initialize' do
    it 'initializes a line with a name' do
      spooky_line = Line.new({:name => 'Haunted Ways'})
      spooky_line.should be_an_instance_of Line
      spooky_line.name.should eq 'Haunted Ways'
    end
  end

  describe '.create' do
    it 'creates a new line and saves it' do
      spooky_line = Line.create({:name => 'Haunted Ways'})
      results = DB.exec("SELECT * FROM lines;")
      results.first['name'].should eq 'Haunted Ways'
    end
  end

  describe '.all' do
    it 'lists all lines' do
      spooky_line = Line.create({:name => 'Haunted Ways'})
      Line.all.first.should eq spooky_line
    end
  end

  describe '#delete' do
    it 'deletes a line from the database' do
      spooky_line = Line.create({:name => 'Haunted Ways'})
      spooky_line.delete
      Line.all.should eq []
    end
  end


  describe '#save' do
    it 'saves a line to the database' do
      spooky_line = Line.new({:name => 'Haunted Ways'})
      spooky_line.save
      results = DB.exec("SELECT * FROM lines;")
      results.first['name'].should eq 'Haunted Ways'
    end
  end

  describe '#edit_name' do
    it 'edits a name of a line' do
      spooky_line = Line.create({:name => 'Haunted line'})
      spooky_line.edit_name('Haunted House line Rainbows')
      Line.all.first.name.should eq 'Haunted House line Rainbows'
    end
  end

  describe '#add_stop' do
    it 'adds a stop to a line by making a new line/station relationship in the database' do
      spooky_line = Line.create({:name => 'Haunted line'})
      spooky_line.add_stop(6)
      results = DB.exec("SELECT * FROM stops WHERE station_id = 6;")
      results.first['line_id'].to_i.should eq spooky_line.id
    end
  end

  describe '#delete_stop' do
    it 'it deletes a stop from a line by deleting the line/station relationship in the database' do
      spooky_line = Line.create({:name => 'Haunted line'})
      spooky_line.add_stop(6)
      results = DB.exec("SELECT * FROM stops WHERE station_id = 6;")
      results.first['line_id'].to_i.should eq spooky_line.id
      spooky_line.delete_stop(6)
      results2 = DB.exec("SELECT * FROM stops WHERE line_id = #{spooky_line.id};")
      results2.first.should eq nil
    end
  end

  describe '#find_stations' do
    it 'finds all the stations on a line' do
      spooky_station = Station.create({:name => 'Haunted Station'})
      crazy_station = Station.create({:name => 'Wild Station'})
      spooky_line = Line.create({:name => 'Haunted line'})
      spooky_line.add_stop(spooky_station.id)
      spooky_line.add_stop(crazy_station.id)
      spooky_line.find_stations[0].name.should eq 'Haunted Station'
    end
  end
end


