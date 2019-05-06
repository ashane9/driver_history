require './lib/driver_history_parser'

if ARGV.length > 0
  ARGV.each do |filename| 
    puts DriverHistoryParser.new.process(File.open(filename))
  end
else
  puts DriverHistoryParser.new.process(STDIN.read.split(/\n/))
end