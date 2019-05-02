require 'rspec'
require './models/driver'


describe 'Driver' do
    before(:each) do
        @driver = Driver.new 'Bob'
    end

    context 'name' do
        it 'will have a name' do
            expect(@driver.name).to eq 'Bob'
        end
    end
end