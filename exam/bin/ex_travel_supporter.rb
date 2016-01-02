# Uzycie programu travel_supporter

require_relative '../lib/travel_supporter'

puts "\n\n"

puts 'Travel Supporter - Asystent podróży'

puts "\n\n"

puts 'Sprawdź godzinę wyjazdu, podaj datę' \
  "\n" \
  'Podaj dzień lub pozostaw puste dla dzisiejszej daty'

day = gets.chomp

if PrepareData.new.check_empty_string(day) == true
  day = TimeGetter.day_getter('')
  month = TimeGetter.month_getter('')
  year = TimeGetter.year_getter('')
  today = true
else
  today = false
  day = TimeGetter.day_getter(day)
  puts 'Podaj miesiąc lub pozostaw puste dla biężacego miesiąca i roku'

  month = gets.chomp

  if PrepareData.new.check_empty_string(month) == true
    month = TimeGetter.month_getter('')
    year = TimeGetter.year_getter('')
  else
    month = TimeGetter.month_getter(month)
    puts 'Podaj rok lub pozostaw puste dla roku'

    year = gets.chomp

    if PrepareData.new.check_empty_string(year) == true
      year = TimeGetter.year_getter('')
    else
      year = TimeGetter.year_getter(year)
    end
  end
end

puts "\n"

puts 'Podaj czas przejazdu do celu, gdy nie ma korków (w minutach)'

casual_time = gets.chomp

puts "\n"

puts 'Podaj godzinę o której chcesz dotrzeć do celu (HH-MM lub HH)'

time = gets.chomp

puts "\n"

if ValidData.new.valid_arrival_time(time) == true
  calculated_time = CalculateTime
                    .new.calculate_time_to_go(time, casual_time,
                                              year, month, day)
end

puts 'Sprawdzasz proponowaną godzinę wyjazdu dla dnia: ' +
  day.to_s + '-' + month.to_s + '-' + year.to_s + ', ' +
  TimeGetter.new.weekday_name(year, month, day)

puts "\n"

time_to_go = 'Aby zdążyć powinieneś wyruszyć o: ' + calculated_time

if (today == true &&
   TimeGetter.new.check_today_time(calculated_time) == false) ||
   TimeGetter.new.check_date(year, month, day) == false

  puts 'Niestety ale proponowana godzina odjazdu już minęła'
else
  puts time_to_go
end

puts "\n"
