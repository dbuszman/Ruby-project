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

  def self.current_time
    time_array = [@time.hour, @time.min]
    time_array
  end

  def self.today_or_tommorow(choose)
    choose = choose.to_i
    if (choose == 1)
      return @time.wday
    else
      if (@time.wday == 6)
        return 0
      else
        return @time.wday + 1
      end
    end
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

  def check_day_of_week(choose)
    day = self.class.today_or_tommorow(choose)

    kind_of_day = case day
                  when 0, 6 then 'weekend'
                  else 'workday'
                  end

    kind_of_day
  end
end

# Prepare data for calculate
class PrepareData
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
  def valid_hours(hour)
    return if hour >= 0 && hour < 24
    fail ArgumentError, 'Invalid hour'
  end

  def valid_minutes(minutes)
    return if minutes >= 0 && minutes < 60
    fail ArgumentError, 'Invalid minutes'
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

  def traffic_time_multiple(arrival_hour, choose)
    kind_of_day = TimeGetter.new.check_day_of_week(choose)
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
  def calculate_route_time(casual_time, arrival_hour, choose)
    route_time = PrepareData.new.casual_travel_time(casual_time) *
                 Traffic.new.traffic_time_multiple(arrival_hour, choose)
    route_time
  end

  def calculate_time_to_go(time, casual_time, choose)
    arrive_time_arr = PrepareData.new.arrival_time_to_array(time)

    arrive_hour = arrive_time_arr[0]
    arrive_minutes = arrive_time_arr[1]

    route_time = CalculateTime.new.calculate_route_time(casual_time,
                                                        arrive_hour, choose).to_i

    hours_to_go = arrive_hour - PrepareData.new
                                .convert_minutes_to_hours(route_time)

    hours_to_go = 24 + hours_to_go if hours_to_go < 0

    minutes_to_go = arrive_minutes - PrepareData.new
                                     .rest_of_minutes(route_time)

    if (minutes_to_go) < 0
      minutes_to_go = 60 + minutes_to_go
      hours_to_go -= 1
    end

    time_to_go = hours_to_go.to_s + '-' + minutes_to_go.to_s
    time_to_go
  end
end
