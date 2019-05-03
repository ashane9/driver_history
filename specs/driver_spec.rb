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
    context 'mph is not between 5 and 100' do
      before(:each) do
        trip = double('Trip')
        allow(trip).to receive(:is_mph_between_5_and_100?) {false}
        @driver.add_trip(trip)
      end
      it 'is discarded' do
        expect(@driver.trips.empty?).to be_truthy
      end
    end

    context 'mph is between 5 and 100' do
      before(:each) do
        @trip = double('Trip')
        allow(@trip).to receive(:is_mph_between_5_and_100?) {true}
        @driver.add_trip(@trip)
      end
      it 'new trip is registered' do
        expect(@driver.trips.last).to be @trip
      end
    end
  end

  describe '#total_mileage' do
    before(:each) do
      trip_1 = double('Trip', miles: 17)
      trip_2 = double('Trip', miles: 22)
      @driver.instance_variable_set(:@trips, [trip_1, trip_2])
    end
    it 'returns the sum of trip mileage' do
      expect(@driver.total_mileage).to eq 39
    end
  end
end