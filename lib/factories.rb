require 'faker'
require 'factory_bot'

class InputData
  attr_accessor :command, :name, :start_ts, :stop_ts, :miles

  def format
    [@command, @name, @start_ts, @stop_ts, @miles].compact.join(' ')
  end
end

FactoryBot.define do
  factory :input_data do
    command {'Driver'}
    name {Faker::Name.first_name}

    trait :trip do
      command {'Trip'}
      start_ts {'10:00'}
      stop_ts {(Time.parse(start_ts) + (Faker::Number.number(3).to_i * 60)).strftime('%H:%M')}
      miles {Faker::Number.decimal(2,1)}
    end
  end

end