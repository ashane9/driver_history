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

  describe '#add_trip' do
    context 'mph is not between 5 and 100' do
      before(:each) do
        allow_any_instance_of(Trip).to receive(:is_mph_between_5_and_100?) {false}
        @driver.add_trip('13:10','20:00','17.4')
      end
      it 'new trip is discarded' do
        expect(@driver.rejected_trips.last).to be_instance_of Trip
      end
    end

    context 'mph is between 5 and 100' do
      before(:each) do
        allow_any_instance_of(Trip).to receive(:is_mph_between_5_and_100?) {true}
        @driver.add_trip('13:10','20:00','17.4')
      end
      it 'new trip is registered' do
        expect(@driver.trips.last).to be_instance_of Trip
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

  describe '#total_time_traveled' do
    before(:each) do
        trip_1 = double('Trip')
        trip_2 = double('Trip')
        allow(trip_1).to receive(:time_difference_in_hours) {10.23}
        allow(trip_2).to receive(:time_difference_in_hours) {6.25}
        @driver.instance_variable_set(:@trips, [trip_1, trip_2])
      end
      it 'returns the sum of trip travel time' do
        expect(@driver.total_time_traveled).to eq 16.48
      end
  end

  describe '#average_mph' do
    context 'acceptable trip' do
      before(:each) do
        allow(@driver).to receive(:total_mileage) {39}
        allow(@driver).to receive(:total_time_traveled) {0.83}
      end
      it 'returns the average trip mph' do
        expect(@driver.average_mph).to eq 47
      end
    end
    context 'mileage is zero' do
      before(:each) do
        allow(@driver).to receive(:total_mileage) {0}
        allow(@driver).to receive(:total_time_traveled) {0.83}
      end
      it 'returns mph as zero' do
        expect(@driver.average_mph).to eq 0
      end
    end
    context 'travel time is zero' do
      before(:each) do
        allow(@driver).to receive(:total_mileage) {39}
        allow(@driver).to receive(:total_time_traveled) {0}
      end
      it 'returns mph as zero' do
        expect(@driver.average_mph).to eq 0
      end
    end
    context 'mileage and travel time is zero' do
      before(:each) do
        allow(@driver).to receive(:total_mileage) {0}
        allow(@driver).to receive(:total_time_traveled) {0}
      end
      it 'returns mph as zero' do
        expect(@driver.average_mph).to eq 0
      end
    end
  end

  describe '#report' do 
    before(:each) do
      allow(@driver).to receive(:total_mileage) {39}
      allow(@driver).to receive(:total_time_traveled) {0.83}
    end
    it 'returns Driver\'s name with total mileage and mph' do
      expect(@driver.report).to eq "Bob: 39 miles @ 47 mph\n"
    end

    context 'zero total mileage' do
      before(:each) do        
        allow(@driver).to receive(:total_mileage) {0}
        allow(@driver).to receive(:total_time_traveled) {0.83}
      end
      it 'returns Driver\'s name with 0 total mileage' do
        expect(@driver.report).to eq "Bob: 0 miles\n"
      end 
    end    

    context 'zero average mph' do
      before(:each) do
        allow(@driver).to receive(:total_mileage) {10}
        allow(@driver).to receive(:total_time_traveled) {0}
      end
      it 'returns Driver\'s name with 0 total mileage' do
        expect(@driver.report).to eq "Bob: 0 miles\n"
      end 
    end  
  end
end