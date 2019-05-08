require 'rspec'
require './lib/trip'

describe 'Trip' do
  before(:each) do
    @start_ts = '10:05'
    @stop_ts = '14:37'
    @miles = '15.6'
    @trip = Trip.new(@start_ts, @stop_ts, @miles)
  end

  describe '#initialize' do
    it 'has a start time' do
      expect(@trip.start_ts).to be_kind_of Time
    end

    it 'has a stop time' do
      expect(@trip.stop_ts).to be_kind_of Time
    end

    it 'has the number of miles driven' do
      expect(@trip.miles).to be_kind_of Integer
    end

    context 'negative miles' do
      it 'raises an ArgumentError' do
        expect{Trip.new('10:10','12:10','-6')}.to raise_error(ArgumentError, "miles -6 cannot be negative")
      end
    end
  end

  describe '.round_to_integer' do
    context 'rounding up to nearest integer' do
      it {expect(Trip.round_to_integer('15.6')).to eq 16}
    end

    context 'rounding down to nearest integer' do
      it {expect(Trip.round_to_integer('14.2')).to eq 14}
    end

    context 'zero remains zero' do
      it {expect(Trip.round_to_integer('0.0')).to eq 0}
    end
  end

  describe '#time_difference_in_hours' do      
    it {expect(@trip.time_difference_in_hours).to be_within(0.01).of(4.53)}

    context 'start and end time are the same' do
      before(:each) do
        time = Time.now
        @trip.instance_variable_set(:@start_ts, time)
        @trip.instance_variable_set(:@stop_ts, time)
      end
      it 'returns time difference as 0' do
        expect(@trip.time_difference_in_hours).to eq 0
      end
    end
  end

  describe '#miles_per_hour' do
    context 'time difference is zero' do
      before(:each) do        
        @trip.instance_variable_set(:@miles, 16)
        allow(@trip).to receive(:time_difference_in_hours) {0}
      end
      it 'returns mph as zero' do
        expect(@trip.miles_per_hour).to eq 0
      end
    end
    context 'miles is zero' do
      before(:each) do        
        @trip.instance_variable_set(:@miles, 0)
        allow(@trip).to receive(:time_difference_in_hours) {4.5}
      end
      it 'returns mph as zero' do
        expect(@trip.miles_per_hour).to eq 0
      end
    end
    it 'returns mph rounded to the nearest integer' do
      expect(@trip.miles_per_hour).to eq 4
    end
  end

  describe '#is_mph_between_5_and_100?' do
    context 'mph is less than 5' do
      before(:each) do
        @trip = Trip.new('12:00', '13:00', '4.0')
      end
      it 'returns false' do
        expect(@trip.is_mph_between_5_and_100?).to be_falsey
      end
    end
    context 'mph is greater than 5' do
      before(:each) do
        @trip = Trip.new('12:00', '13:00', '101.0')
      end
      it 'returns false' do
        expect(@trip.is_mph_between_5_and_100?).to be_falsey
      end
    end
    context 'mph is greater than 4 and less than 101' do
      before(:each) do
        @trip = Trip.new('12:00', '13:00', '60.0')
      end
      it 'returns true' do
        expect(@trip.is_mph_between_5_and_100?).to be_truthy
      end
    end
  end

end