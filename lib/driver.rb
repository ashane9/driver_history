require './lib/trip'

class Driver
  attr_reader :name, :trips, :rejected_trips

  def initialize(name)
    @name = name
    @trips = []
    @rejected_trips = []
  end

  def add_trip(start_ts, stop_ts, miles)    
    new_trip = Trip.new(start_ts, stop_ts, miles)
    if new_trip.is_mph_between_5_and_100?
      @trips << new_trip
    else
      @rejected_trips << "Trip #{@name} #{start_ts} #{stop_ts} #{miles}"
    end
  end

  def total_mileage
    @trips.map{|trip| trip.miles}.sum
  end

  def total_time_traveled    
    @trips.map{|trip| trip.time_difference_in_hours}.sum
  end

  def average_mph
    begin
      (total_mileage / total_time_traveled).round
    rescue ZeroDivisionError
      0
    end
  end

  def report
    if average_mph == 0
      "#{@name}: 0 miles\n"
    else
      "#{@name}: #{total_mileage} miles @ #{average_mph} mph\n"
    end
  end

end