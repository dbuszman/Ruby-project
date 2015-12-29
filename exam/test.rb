#!/usr/bin/ruby -w

# Get time data
class TimeGetter
  @time = Time.new

  def self.current_date
    @time.year.to_s + '-' +
      @time.month.to_s + '-' +
      @time.day.to_s
  end

  def self.day_of_week
    day = case @time.wday
          when 0 then 'Sunday'
          when 1 then 'Monday'
          when 2 then 'Tuesday'
          when 3 then 'Wednesday'
          when 4 then 'Thursday'
          when 5 then 'Friday'
          when 6 then 'Saturday'
          end
    day
  end

  def self.current_hour
    @time.hour
  end
end

# Information about traffic
class Traffic
  def traffic_jam_hour
    traffic = case TimeGetter.current_hour
              when 6, 9, 13 then 'Possible'
              when 7..8 then 'Traffic'
              when 14..16 then 'Traffic'
              when 17..18 then 'Possible'
              else 'False'
              end
    traffic
  end

  def traffic_time_multiple
    multiple = case traffic_jam_hour
               when 'Possible' then 1.5
               when 'Traffic' then 2.5
               else 1
               end
    multiple
  end
end

# Get data from user and calculate
class UserData
  def casual_travel_time
    puts 'How long do you usually passes your route (in minutes)?'
    travel_time = gets.chomp.to_i
    travel_time
  end

  def time_to_arrive
    puts 'At what time do you want to get to your destination? (HH-MM)'
    arrive_time = gets.chomp
    arrive_time
  end

  def arr_arrive
    arr_time = time_to_arrive.split(/-/)
    arr_time
  end

  def calculate_route_time
    route_time = casual_travel_time * Traffic.new.traffic_time_multiple
    route_time
  end

  def convert_minutes_to_hours(time)
    hour = 0
    (time >= 60) && (hour = time / 60)
    hour
  end

  def rest_of_minutes(time)
    minutes = time % 60
    minutes
  end

  def calculated_arrive_time
    arrive_time_arr = arr_arrive
    route_time = calculate_route_time
    arrive_hour = arrive_time_arr[0].to_i
    arrive_minutes = arrive_time_arr[1].to_i

    hours_to_go = arrive_hour - convert_minutes_to_hours(route_time)
    if hours_to_go < 0
      hours_to_go = 24 + hours_to_go
    end
    minutes_to_go = arrive_minutes - rest_of_minutes(route_time)
    if (minutes_to_go) < 0
      minutes_to_go = 60 + minutes_to_go
      hours_to_go -= 1
    end

    puts 'You should go at: ' + hours_to_go.to_s + '-' + minutes_to_go.to_s
  end
end

puts 'Today is: ' + TimeGetter.current_date
puts TimeGetter.day_of_week

# puts TimeGetter.current_hour.to_s
# puts Traffic.new.traffic_jam_hour
# puts Traffic.new.traffic_time_multiple.to_s

UserData.new.calculated_arrive_time

# puts UserData.new.time_to_arrive
