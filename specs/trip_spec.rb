require './env'
require './models/trip'


describe 'A single Trip' do
    before(:each) do
        @start_ts = '10:05'
        @stop_ts = '14:37'
        @miles = '15.6'
        @trip = Trip.new(@start_ts, @stop_ts, @miles)
    end

    context 'Start Time' do
        it 'will have a start time' do
            expect(@trip.start_ts).to be_kind_of Time
        end
    end

    context 'Stop Time' do
        it 'will have a stop time' do
            expect(@trip.stop_ts).to be_kind_of Time
        end
    end

    context 'Miles' do 
        it 'will have the number of miles driven' do
            expect(@trip.miles).to be_kind_of Integer
        end

        it 'will round the miles to the nearest integer' do
            expect(@trip.miles).to eq 16
        end
    end

    context 'Miles Per Hour' do
        it 'will be calculated based on duration and number of miles, rounded to the nearest integer' do
            expect(@trip.miles_per_hour).to eq 3
        end
    end

end