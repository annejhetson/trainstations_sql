require 'spec_help'

describe Station do
  describe '.initialize' do
    it 'initializes a station with a name' do
      testy_station = Station.new({:name => 'Mystery Station'})
      testy_station.should be_an_instance_of Station
      testy_station.name.should eq 'Mystery Station'
    end
  end

  describe '.create' do
    it 'creates and saves a new station' do
      testy_station = Station.create({:name => "Horror Station"})
      results = DB.exec("SELECT * FROM stations WHERE name = 'Horror Station';")
      results.first['name'].should eq 'Horror Station'
    end
  end

  describe '.all' do
    it 'lists all stations' do
      testy_station = Station.create({:name => "Pirate Station"})
      Station.all.first.name.should eq 'Pirate Station'
    end
  end

  describe '#save' do
    it 'saves a station to the database' do
      testy_station = Station.new({:name => "Horror Station"})
      testy_station.save
      results = DB.exec("SELECT * FROM stations WHERE name = 'Horror Station';")
      results.first['name'].should eq 'Horror Station'
    end
  end

  describe '#delete' do
    it 'deletes a station from the database' do
      spooky_station = Station.create({:name => 'Haunted Station'})
      spooky_station.delete
      Station.all.should eq []
    end
  end

  describe '#edit_name' do
    it 'edits a name of a station' do
      spooky_station = Station.create({:name => 'Haunted Station'})
      spooky_station.edit_name('Haunted House Station Rainbows')
      Station.all.first.name.should eq 'Haunted House Station Rainbows'
    end
  end

  describe '#find_lines' do
    it 'finds all the lines that stop at the station' do
      spooky_station = Station.create({:name => 'Haunted Station'})
      spooky_line = Line.create({:name => 'Haunted line'})
      spooky_line.add_stop(spooky_station.id)
      spooky_line.add_stop(1)
      spooky_station.find_lines.first.name.should eq 'Haunted line'
    end
  end

end
