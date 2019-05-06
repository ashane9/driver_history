require './lib/driver_history_parser'

# @driver_history = DriverHistoryParser.new
if ARGV.length > 0
  ARGV.each do |filename| 
    # @driver_history.process(File.open(filename))
    puts DriverHistoryParser.new.process(File.open(filename))
  end
else
  # @driver_history.process(STDIN.read.split(/\n/))
  puts DriverHistoryParser.new.process(STDIN.read.split(/\n/))
end

# puts @driver_history.report