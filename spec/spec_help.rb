require 'rspec'
require 'pg'
require 'stations'
require 'lines'

DB = PG.connect({:dbname => 'trymet_test'})


RSpec.configure do |config|
  config.before(:each) do
    DB.exec("DELETE FROM stations *;")
    DB.exec("DELETE FROM lines *;")
    DB.exec("DELETE FROM stops *;")
  end
end
