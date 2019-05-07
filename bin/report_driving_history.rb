require './lib/driving_history_tracker'

if ARGV.length > 0
  puts "Process Start Time: #{Time.now.strftime('%H:%M:%S')}\n"
  output = DrivingHistoryTracker.new.process(File.open(ARGV[0]))
  puts "Process End Time: #{Time.now.strftime('%H:%M:%S')}\n"
  case ARGV[1]
  when '-o'
    File.open('results.txt','w') {|f| f.puts output}
  else
    puts output
  end
else
  puts DrivingHistoryTracker.new.process(STDIN.read.split(/\n/))
end