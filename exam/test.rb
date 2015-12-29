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


puts 'Today is: ' + TimeGetter.current_date
puts TimeGetter.day_of_week
puts TimeGetter.current_hour.to_s
puts Traffic.new.traffic_jam_hour
puts Traffic.new.traffic_time_multiple.to_s
