#!/usr/bin/ruby -w

require 'date'

# Get time data
class TimeGetter
  @time = Time.new

  def self.current_date
    @time.year.to_s + '-' +
      @time.month.to_s + '-' +
      @time.day.to_s
  end

  def self.day_of_week
    day = @time.strftime('%A')
    day
  end

  def self.current_time
    time_array = [@time.hour, @time.min]
    time_array
  end

  def weekday(y, m, d)
    Date.new(y, m, d).wday
  end

  def self.day_getter(day)
    day = day.strip
    return day.to_i if day != ''
    day = @time.day
    day
  end

  def self.month_getter(month)
    month = month.strip
    return month.to_i if month != ''
    month = @time.month
    month
  end

  def self.year_getter(year)
    year = year.strip
    return year.to_i if year != ''
    year = @time.year
    year
  end

  # This method compare calculated time with current time
  def check_today_time(calculated_time)
    calculated_time_arr = PrepareData.new.arrival_time_to_array(calculated_time)
    current_time_arr = self.class.current_time

    if current_time_arr[0] == calculated_time_arr[0] &&
       current_time_arr[1] < calculated_time_arr[1]
      return true
    elsif current_time_arr[0] < calculated_time_arr[0]
      return true
    else
      return false
    end
  end

  def check_day_of_week(y, m, d)
    day = weekday(y, m, d)

    kind_of_day = case day
                  when 0, 6 then 'weekend'
                  else 'workday'
                  end

    kind_of_day
  end
end

# Prepare data for calculate
class PrepareData
  def check_empty_string(string)
    string = string.strip
    if string == ''
      true
    else
      false
    end
  end

  def casual_travel_time(time)
    travel_time = time.to_i
    travel_time
  end

  def arrival_time_to_array(time)
    arr_time = time.split(/-/).map(&:to_i)
    arr_time
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
end

# Check data
class ValidData
  def valid_arrival_time(time)
    if /(\d{2}-\d{2})/.match(time)
      true
    else
      fail ArgumentError, 'Invalid time format'
    end
  end

  def valid_hours(time)
    arrive_time_arr = PrepareData.new.arrival_time_to_array(time)
    hour = arrive_time_arr[0]
    if hour < 0 || hour >= 24
      fail ArgumentError, 'Invalid hour'
    else
      true
    end
  end

  def valid_minutes(time)
    arrive_time_arr = PrepareData.new.arrival_time_to_array(time)
    minutes = arrive_time_arr[1]
    if minutes < 0 || minutes >= 60
      fail ArgumentError, 'Invalid minutes'
    else
      true
    end
  end
end

# Information about traffic
class Traffic
  def traffic_jam_hour_weekend(arrival_hour)
    traffic = case arrival_hour
              when 8..11 then 'Possible'
              when 12..15 then 'Traffic'
              when 16..18 then 'Possible'
              else 'False'
              end
    traffic
  end

  def traffic_jam_hour_workday(arrival_hour)
    traffic = case arrival_hour
              when 6, 9, 13 then 'Possible'
              when 7..8 then 'Traffic'
              when 14..16 then 'Traffic'
              when 17..18 then 'Possible'
              else 'False'
              end
    traffic
  end

  def traffic_time_multiple(arrival_hour, y, m, d)
    kind_of_day = TimeGetter.new.check_day_of_week(y, m, d)
    if (kind_of_day == 'weekend')
      traffic_jam_hour = traffic_jam_hour_weekend(arrival_hour)
    else
      traffic_jam_hour = traffic_jam_hour_workday(arrival_hour)
    end
    multiple = case traffic_jam_hour
               when 'Possible' then 1.5
               when 'Traffic' then 2.5
               else 1
               end
    multiple
  end
end

# Calculate time to go
class CalculateTime
  def calculate_route_time(casual_time, arrival_hour, y, m, d)
    route_time = PrepareData.new.casual_travel_time(casual_time) *
                 Traffic.new.traffic_time_multiple(arrival_hour, y, m, d)
    route_time
  end

  def calculate_time_to_go(time, casual_time, y, m, d)
    arrive_time_arr = PrepareData.new.arrival_time_to_array(time)

    arrive_hour = arrive_time_arr[0]
    arrive_minutes = arrive_time_arr[1]

    route_time = CalculateTime.new.calculate_route_time(casual_time,
                                                        arrive_hour,
                                                        y, m, d).to_i

    hours_to_go = arrive_hour - PrepareData.new
                                .convert_minutes_to_hours(route_time)

    hours_to_go = 24 + hours_to_go if hours_to_go < 0

    minutes_to_go = arrive_minutes - PrepareData.new
                                     .rest_of_minutes(route_time)

    if (minutes_to_go) < 0
      minutes_to_go = 60 + minutes_to_go

      hours_to_go -= 1
      return hours_to_go if (hours_to_go) >= 0
      hours_to_go = 24 + hours_to_go
    end

    time_to_go = hours_to_go.to_s + '-' + minutes_to_go.to_s

    time_to_go
  end
end
