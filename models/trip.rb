class Trip
    attr_reader :start_ts, :stop_ts, :miles

    def initialize(start_ts, stop_ts, miles)
        @start_ts = Time.parse(start_ts)
        @stop_ts = Time.parse(stop_ts)
        @miles = miles.to_f.round
    end

    def miles_per_hour
        (@miles / time_difference_in_hours).round
    end

    def time_difference_in_hours
        (@stop_ts - @start_ts) / 3600
    end
end