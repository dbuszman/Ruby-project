# Uzycie programu travel_supporter

require_relative '../lib/travel_supporter'

puts "\n\n"

puts 'Travel Supporter - Asystent podróży'

puts "\n\n"

puts 'Sprawdzasz dla dzisiaj - wciśnij 1,' \
  "\n" \
  'dla jutra - wciśnij dowolny klawisz'

choose = gets.chomp

puts "\n"

puts 'Podaj czas przejazdu do celu, gdy nie ma korków (w minutach)'

casual_time = gets.chomp

puts "\n"

puts 'Podaj godzinę o której chcesz dotrzeć do celu (HH-MM)'

time = gets.chomp

puts "\n"

if ValidData.new.valid_hours(time) == true &&
   ValidData.new.valid_minutes(time) == true
  calculated_time = CalculateTime.
                    new.calculate_time_to_go(time, casual_time, choose)
end

time_to_go = 'Aby zdążyć powinieneś wyruszyć o: ' + calculated_time

if choose == '1' && TimeGetter.new.check_today_time(calculated_time) == false
  puts 'Niestety ale godzina proponowanego odjazdu już minęła'
else
  puts time_to_go
end
