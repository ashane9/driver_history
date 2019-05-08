require './lib/factories'

def generate(number)
  number||=100
  File.open('./data/input.txt', 'w') do |f|
    number.to_i.times do 
      f << FactoryBot.build(:input_data, [nil,:trip].sample).format + "\n"
    end
  end
end

generate ARGV[0]
