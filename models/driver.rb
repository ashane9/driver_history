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

    def add_trip(start_ts, stop_ts, miles)
        new_trip = create_trip(start_ts, stop_ts, miles)
        @trips << new_trip
    end

end