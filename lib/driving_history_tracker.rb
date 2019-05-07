require './lib/driver'

class DrivingHistoryTracker
  attr_reader :drivers, :rejected_entries

  def initialize
    @drivers = []
    @rejected_entries = []
  end

  def process(input)
    drivers, input = input.partition{|line| line.split(/\s/).first.downcase.include? "driver"}
    trips, rejects = input.partition{|line| line.split(/\s/).first.downcase.include? "trip"}
    @rejected_entries = rejects
    register_drivers(drivers)
    record_trips(trips)
    report
  end

  def find_driver(name)
    @drivers.select{|driver| driver.name.downcase == name.downcase}.first
  end

  def register_drivers(drivers)
    drivers.each do |driver_entry|
      unless driver_entry.split(/\s/).size == 2
        @rejected_entries << driver_entry 
        next
      end
      drivers_name = driver_entry.split(/\s/).last
      @drivers << Driver.new(drivers_name) if find_driver(drivers_name).nil?
    end
  end

  def record_trips(trips)
    trips.each do |trip_entry|
      unless trip_entry.split(/\s/).delete_if(&:empty?).size == 5
        @rejected_entries << trip_entry
        next
      end
      trip_data = trip_entry.split(/\s/)
      drivers_name = trip_data[1]
      driver = find_driver(drivers_name)
      if driver.nil?
        @rejected_entries << trip_entry
        next
      end
      start_ts = trip_data[2]
      stop_ts = trip_data[3]
      miles = trip_data[4]
      driver.add_trip(start_ts,stop_ts,miles)
    end
  end

  def report
    report = ''
    @drivers.sort_by{|driver| driver.total_mileage}.reverse.each do |driver|
      report += driver.report   
      @rejected_entries << driver.rejected_trips.flatten
    end
    report
  end
end