require 'driver'
require 'trip'

if ARGV.length > 0
  ARGV.each do |filename| 
    DriverHistoryParser.parse(filename)
  end
else
  puts STDIN.read
end

DriverHistoryParser.register_drivers
DriverHistoryParser.record_trips
