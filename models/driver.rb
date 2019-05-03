require './models/trip'

class Driver
  attr_reader :name, :trips

  def initialize(name)
    @name = name
    @trips = []
  end

  def create_trip(start_ts, stop_ts, miles)
    Trip.new(start_ts, stop_ts, miles)
  end

  def add_trip(new_trip)
    @trips << new_trip if new_trip.is_mph_between_5_and_100?
  end

  def total_mileage
    @trips.map{|trip| trip.miles}.sum
  end

  def total_time_traveled    
    @trips.map{|trip| trip.time_difference_in_hours}.sum
  end

  def average_mph
    (total_mileage / total_time_traveled).round
  end

end