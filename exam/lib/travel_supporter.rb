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

# Prepare data for calculate
class PrepareData
  def casual_travel_time(time)
    travel_time = time.to_i
    travel_time
  end

  def arrival_time_to_array(time)
    arr_time = time.split(/-/).to_i
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
    raise ArgumentError, 'Invalid hour'
  end
end
