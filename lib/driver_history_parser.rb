class DriverHistoryParser
  attr_reader :driver

  def << self
    @driver = []
  end

  def parse(filename)
    File.read(filename).each do |line|
      command = line.split(/\s/).first.downcase.delete

    end
  end
end