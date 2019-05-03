require 'time'

class Trip
  attr_reader :start_ts, :stop_ts, :miles

  def initialize(start_ts, stop_ts, miles)
    @start_ts = Time.parse(start_ts)
    @stop_ts = Time.parse(stop_ts)
    @miles = self.class.round_to_integer(miles)
  end

  def self.round_to_integer(value)
    value.to_f.round
  end

  def miles_per_hour
    (@miles / time_difference_in_hours).round
  end

  def time_difference_in_hours
    (@stop_ts - @start_ts) / 3600
  end

  def is_mph_between_5_and_100?
    miles_per_hour > 4 and miles_per_hour < 101
  end
end