require 'pg'
require './lib/stations'
require './lib/Lines'
require 'pry'

DB = PG.connect({:dbname => 'trymet'})

def greeting
  puts "Welcome to oooowl trymet train system..once you enter, you never leeeeeave..."
  sleep(3)
  puts "Would you like to enterrrrrr?"
  gets
  puts "You are coming in whether you like it or not!!! ha ha ha"
  main_menu
end

def main_menu
  puts  "                      :oooooooooo:
                        ::oOOOOooo:::::ooooO88Oo:
                     :oOOo:                   :oO8O:
                  :O8O:                           oO8o
                O8O:                                 :OO:
              o8o                                      :8o
             88:                                         O8:
           o8o                                            :8o
          8O:                                               oO
         8o                                                  oO
        8o                                                    Oo
      :8o                                              :      :8:
     :8:                                               :       :8:
    :8:                                               :o        oO
    O::o                                              oo         8:
   :o:ooO                                             oo         o8
   8    oo                                            :o          8o
  oo     8o                                            OO:        :8
  8      o8:                                            O8O:       8:
 :o      :88                                             :8O       :O
 o:     ::88:                                             O8        8
 8       888:                                             O8o       O
:8       :88:                                             888Ooo:   oo
oo       oO8:                                             888888o   :O
Oo       O88           :oO88O:            oO88Oo:         O8888O    :O
O:  ::   :88      :oO888888888:          8888888888OOo:    8888:    :O
O:  :o    8o   o88888888888888:          88888888888888O:   o88     :O
Oo   oo  oO  o888888888888888O           8888888888888888o   88     :O
:O    O: oo  8888888888888888:          o88888888888888888   88     :O
 8    :o:8:  8888888888888888:::         :8888888888888888  o888o:::8O
 O:   :88:   O88888888888888888           O888888888888888  o88888888O
  o   :8O    o888888888888888O            O88888888888888O   88888888o
  O:  :8:    88888888888888O:      :      O888888888888888   O8888888:
  :O  :8     88888888888888       o88:    :o88888888888888    8888888
   OoooO    :8888888888O:8o      :8O88       :O8888888888o     O888oo
    888:     8888888o:  8O       :8o88O         O888888O:          :
    :88       oOOo:   :O:        :8:888          8o
     88              o:          88oO88o      :: :oo            :
     88::               oo      O88O:888o    O8o:   :   ::     : :
     8o o:                     o88oo O888    :8        :88   :: ::
     oO  oo     o              O8o : O888     :o       oO8o ::  O
      O:  Oo  ::o              OO    OO :             :oO88 O::O:
       O  :8: :88o             OO    Oo             :O888O  8OO:
       oo  Oo  O888o           :O:o:  :            o8888o  :O
        :O888  :88888           :o  Oo            o8888o   8:
           :8:  O8888               8            :O888O   :8
            Oo  :8888               o             :888    :O
            :O   o888  ::                         o88:    Oo
            :O    O88OO8oOOoOOoOooOooOOOOOOOOOO88O88O     O:
            OO     888:: o :o: o  o   O: 8: O o::o 8:     8
           :8O     :88o:  :    :  :      ::        8      O
           O8o      Oo:8oo:    :          :   :::oo8     :O
           88o      Oo O :ooOOOoOO:OO   :8O:O O  o O     :O
           88o      Oo :      o:o: :o    Oo : :  o       :O
           88O       :oo:oo:o o :  :: oo :: o O::o       o:
           888         :::::oO8O8OoO8O88oOOoo:         :Oo
            O88Oo::               ::                  :O
             :oO8888o                               :Oo
                 :o88o                      oo    o8O:
                    O8o                     Oo  o88o
                     o8O     Oo    o           o88
                      :88o        O:          O88
                        O88o     :8o        o88O
                          o88ooOO888O::::oO88O:
                            o8888888888888Oo
"
  puts "Enter 'O' if you are a train master"
  puts "Enter 'R' if you are a ghost rider"
  choice = gets.downcase.chomp
  case choice
  when "o"
    puts "enter secret password"
    password = gets.downcase.chomp
    if password == "thriller"
      train_master_menu
    else
      puts "╭∩╮ (òÓ,) ╭∩╮"
      sleep(2)
      main_menu
    end
  when 'r'

    ghost_rider_menu
  else
    main_menu
  end
end

def train_master_menu
  puts 'Would you like to work with Stations or Lines?'
  answer = gets.downcase.chomp
  case answer[0]
  when 's'
    stations_menu
  when 'l'
    lines_menu
  else
    puts 'exit? y/n'
    exit = gets.downcase.chomp
    if exit == 'y'
      main_menu
    else
      train_master_menu
    end
  end
end

def stations_menu
  puts 'Options:
                              "L" - List all stations
                              "S" - Search for a station
                              "A" - Add a station
                              "E" - Edit a station
                              "D" - Delete a station
                              "V" - View a station
                              "B" - main_menu'
  choice = gets.downcase.chomp
  case choice
  when 'l'
    Station.all.collect {|station| puts station.name}
    puts "ʕ•̫͡•ʕ*̫͡*ʕ•͓͡•ʔ-̫͡-ʕ•̫͡•ʔ*̫͡*ʔ-̫͡-ʔ"
    stations_menu
  when 's'
    puts "please enter the name of the station you would like to find:"
    this_station = gets.downcase.chomp
    results = DB.exec("SELECT * FROM stations WHERE name = '#{this_station}';")
    temp_station = Station.new({:name => results.first['name'], :id => results.first['id']})
    puts "Station Name: #{temp_station.name} #{'='*25} Lines at this station:"
    lines = temp_station.find_lines
    lines.collect {|line| puts line.name}
    stations_menu
  when 'a'
    puts "What would you like to name the new station?"
    station_name = gets.downcase.chomp
    Station.create({:name => station_name})
    puts "Processing...."
    sleep(1)
    puts "Station '#{station_name}' has been successfully added to our Trymet system"
    stations_menu

  when 'e'
  when 'd'
  when 'v'
  when 'b'
    main_menu
  else
    puts "╭∩╮ (òÓ,) ╭∩╮"
    sleep(2)
    stations_menu
  end
end

def lines_menu

end

greeting
# Hello Spyder & Ann,

# Welcome back from you coffee run.

# I've missed you. Please keep typing in me.
