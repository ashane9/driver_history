require './env'
require './models/driver'


describe 'Driver' do
    before(:each) do
        @driver = Driver.new 'Bob'
    end

    describe '#initialize' do
        it 'has a name' do
            expect(@driver.name).to eq 'Bob'
        end
    end

    describe '#create_trip' do
        it 'returns a new Trip' do
          expect(@driver.create_trip('13:10', '20:00', '17.4')).to be_instance_of Trip
        end
    end

    describe '#add_trip' do
      before(:each) do
        trip = instance_double('Trip', start_ts: '13:10', stop_ts: '20:00', miles: 17.4)
        @driver.add_trip(trip)
      end

        context 'average speed is less than 5 mph' do
            it 'is discarded' do
                expect(@driver.trips.empty?).to be_truthy
            end
        end

        context 'average speed is greater than 100 mph' do
            it 'is discarded' do
                expect(@driver.trips.empty?).to be_truthy
            end
        end
        it 'new trip is registered' do
            expect(@driver.trips.last).to be_instance_of Trip
        end
    end
end