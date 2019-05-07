require 'rspec'
require './lib/driving_history_tracker'
require './lib/driver'

describe 'DrivingHistoryTracker' do
  before(:each) do
    @driver_history = DrivingHistoryTracker.new
  end
  
  describe('#find_driver') do
    before(:each) do
      @driver = double('Driver', name: 'Alan')
      @driver_history.instance_variable_set(:@drivers, [@driver])
    end
    context 'driver not found' do
      it 'returns nil' do
        expect(@driver_history.find_driver('John')).to be_nil
      end
    end

    context 'driver found by same case' do
      it 'returns the driver by name' do
        expect(@driver_history.find_driver('Alan')).to eq @driver
      end
    end

    context 'driver found by case mismatch' do
      it 'returns the driver by name' do
        expect(@driver_history.find_driver('aLAn')).to eq @driver
      end
    end    
  end
  
  describe('#register_drivers') do
    context 'missing delimiter' do
      before(:each) do
        @driver_entry = 'Driver'
        @driver_history.register_drivers([@driver_entry])
      end
      it 'registers zero drivers' do
        expect(@driver_history.drivers.empty?).to be_truthy
      end

      it 'entry is rejected' do
        expect(@driver_history.rejected_entries.include?(@driver_entry)).to be_truthy
      end
    end

    context 'extra delimiter' do
      before(:each) do
        @driver_entry = 'Driver Dan Doberman'
        @driver_history.register_drivers([@driver_entry])
      end
      it 'registers zero drivers' do
        expect(@driver_history.drivers.empty?).to be_truthy
      end

      it 'entry is rejected' do
        expect(@driver_history.rejected_entries.include?(@driver_entry)).to be_truthy
      end

    end

    context 'zero drivers' do
      before(:each) do
        @driver_history.register_drivers([])
      end
      it 'registers zero drivers' do
        expect(@driver_history.drivers.empty?).to be_truthy
      end
    end

    context 'driver with no name' do
      before(:each) do
        @driver_entry = 'Driver '
        @driver_history.register_drivers([@driver_entry])
      end
      it 'registers zero drivers' do
        expect(@driver_history.drivers.empty?).to be_truthy
      end

      it 'entry is rejected' do
        expect(@driver_history.rejected_entries.include?(@driver_entry)).to be_truthy
      end
    end

    context 'one driver' do
      before(:each) do
        @driver_history.register_drivers(['Driver Tom'])
      end
      it 'registers one driver' do
        expect(@driver_history.drivers.size).to eq 1
      end 

      it 'initializes one driver' do      
        expect(@driver_history.drivers.first).to be_instance_of Driver
      end

      it 'driver\'s name is stored' do
        expect(@driver_history.drivers.first.name).to eq 'Tom'  
      end
    end

    context 'multiple drivers' do      
      before(:each) do
        @driver_history.register_drivers(['Driver Tom', 'driver bill'])
      end
      it 'registers two drivers' do
        expect(@driver_history.drivers.size).to eq 2
      end 

      it 'initializes second driver' do      
        expect(@driver_history.drivers.last).to be_instance_of Driver
      end

      it 'second driver\'s name is stored' do
        expect(@driver_history.drivers.last.name).to eq 'bill'  
      end
    end

    context '2 drivers with same name' do
      before(:each) do
        @driver_history.register_drivers(['Driver Steve','Driver steve'])
      end
      it 'registers first driver' do
        expect(@driver_history.drivers.size).to eq 1
      end

      it 'skips registering the second driver' do
        expect(@driver_history.drivers.first.name).not_to eq 'steve'
      end
    end
  end

  describe('#record_trips') do  
    context 'trip with missing information' do
      context 'missing delimiter' do
        before(:each) do
          @trip_entry = 'Trip 1'
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end

      context 'exta delimiter' do
        before(:each) do
          @trip_entry = 'Trip Sam Samsonite 10:10 12:10 12'
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end

      context 'driver is blank' do
        before(:each) do
          @trip_entry = 'Trip  10:10 12:10 12'
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end

      context 'start time is blank' do
        before(:each) do
          @trip_entry = 'Trip Sam  12:10 12'
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end

      context 'stop time is blank' do
        before(:each) do
          @trip_entry = 'Trip Sam 12:10  12'
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end

      context 'mileage is blank' do
        before(:each) do
          @trip_entry = 'Trip Jeff 10:10 12:10 '
          @driver_history.record_trips([@trip_entry])
        end
  
        it 'entry is rejected' do
          expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
        end
      end
    end

    context 'driver not found' do
      before(:each) do
        @trip_entry = 'Trip Reject 10:10 12:10 12'
        @driver_history.record_trips([@trip_entry])
      end

      it 'entry is rejected' do
        expect(@driver_history.rejected_entries.include?(@trip_entry)).to be_truthy
      end
    end

    context 'one driver' do
      context 'zero trips' do
        before(:each) do
          @driver = Driver.new('Sam')
          @driver_history.instance_variable_set(:@drivers, [@driver])
          @driver_history.record_trips([])
        end
  
        it 'zero trips are recorded for driver' do
          expect(@driver.trips.empty?).to be_truthy
        end 
      end

      context 'one trip' do
        before(:each) do
          @driver = Driver.new('Sam')
          @driver_history.instance_variable_set(:@drivers, [@driver])
          trip_entry = 'Trip Sam 10:10 12:10 12'
          @driver_history.record_trips([trip_entry])
        end
  
        it 'trip is recorded for driver' do
          expect(@driver.trips.first).to be_instance_of Trip
        end 
      end

      context 'multiple trips' do         
        before(:each) do
          @driver = Driver.new('Sam')
          @driver_history.instance_variable_set(:@drivers, [@driver])
          trip_entry_1 = 'Trip Sam 10:10 12:10 12'
          trip_entry_2 = 'Trip Sam 13:30 15:10 22.7'
          @driver_history.record_trips([trip_entry_1,trip_entry_2])
        end
  
        it 'trips are recorded for driver' do
          expect(@driver.trips.size).to eq 2
        end 
      end
    end

    context 'multiple drivers' do 
      context 'zero trips' do 
        before(:each) do
          @driver_1 = Driver.new('Sam')
          @driver_2 = Driver.new('Ken')
          @driver_history.instance_variable_set(:@drivers, [@driver_1, @driver_2])
          @driver_history.record_trips([])
        end
  
        it 'no trip is recorded for driver_1' do
          expect(@driver_1.trips.empty?).to be_truthy
        end 
        it 'no trip is recorded for driver_2' do
          expect(@driver_2.trips.empty?).to be_truthy
        end 
      end

      context 'one trip' do        
        context 'for each driver' do
          before(:each) do
            @driver_1 = Driver.new('Sam')
            @driver_2 = Driver.new('Ken')
            @driver_history.instance_variable_set(:@drivers, [@driver_1, @driver_2])
            trip_entry_1 = 'Trip Sam 10:10 12:10 12'
            trip_entry_2 = 'Trip Ken 10:10 12:10 12'
            @driver_history.record_trips([trip_entry_1,trip_entry_2])
          end
    
          it 'trip is recorded for driver_1' do
            expect(@driver_1.trips.size).to eq 1
          end 
          it 'trip is recorded for driver_2' do
            expect(@driver_2.trips.size).to eq 1
          end 
        end
        context 'for one driver' do
          before(:each) do
            @driver_1 = Driver.new('Sam')
            @driver_2 = Driver.new('Ken')
            @driver_history.instance_variable_set(:@drivers, [@driver_1, @driver_2])
            trip_entry = 'Trip Sam 10:10 12:10 12'
            @driver_history.record_trips([trip_entry])
          end
    
          it 'trip is recorded for driver_1' do
            expect(@driver_1.trips.size).to eq 1
          end 

          it 'no trip is recorded for driver_2' do
            expect(@driver_2.trips.empty?).to be_truthy
          end 
        end
      end

      context 'multiple trips' do 
        context 'for each driver' do
          before(:each) do
            @driver_1 = Driver.new('Sam')
            @driver_2 = Driver.new('Ken')
            @driver_history.instance_variable_set(:@drivers, [@driver_1, @driver_2])
            trip_entry_1 = 'Trip Sam 10:10 12:10 12'
            trip_entry_2 = 'Trip Ken 10:10 12:10 12'
            trip_entry_3 = 'Trip Sam 10:10 12:10 12'
            trip_entry_4 = 'Trip Ken 10:10 12:10 12'
            @driver_history.record_trips([trip_entry_1,trip_entry_2,trip_entry_3,trip_entry_4])
          end
    
          it 'trips are recorded for driver_1' do
            expect(@driver_1.trips.size).to eq 2
          end 
          it 'trips are recorded for driver_2' do
            expect(@driver_2.trips.size).to eq 2
          end 
        end
        context 'for one driver' do
          before(:each) do
            @driver_1 = Driver.new('Sam')
            @driver_2 = Driver.new('Ken')
            @driver_history.instance_variable_set(:@drivers, [@driver_1, @driver_2])
            trip_entry_1 = 'Trip Sam 10:10 12:10 12'            
            trip_entry_2 = 'Trip Sam 10:10 12:10 12'
            @driver_history.record_trips([trip_entry_1,trip_entry_2])
          end
    
          it 'trips are recorded for driver_1' do
            expect(@driver_1.trips.size).to eq 2
          end 

          it 'no trip is recorded for driver_2' do
            expect(@driver_2.trips.empty?).to be_truthy
          end 
        end
      end
    end
  end

  describe('#report') do
    context 'zero drivers' do
      it 'returns nothing' do
        expect(@driver_history.report).to eq ''
      end
    end
    context 'one driver' do
      before(:each) do
        @driver_report = "Allison: 15 miles @ 15 mph\n"
        driver = double('Driver', report: @driver_report, rejected_trips: [])
        allow(driver).to receive(:total_mileage) {15}
        @driver_history.instance_variable_set(:@drivers, [driver])
      end
      it 'returns single driver report' do
        expect(@driver_history.report).to eq @driver_report 
      end 
    end

    context 'multiple drivers' do
      before(:each) do
        @driver_1_report = "Allison: 15 miles @ 15 mph\n"
        @driver_2_report = "Andrew: 25 miles @ 30 mph\n"
        driver_1 = double('Driver', total_mileage: 15, report: @driver_1_report, rejected_trips: [])
        driver_2 = double('Driver', total_mileage: 25, report: @driver_2_report, rejected_trips: [])
        @driver_history.instance_variable_set(:@drivers, [driver_1,driver_2])
      end
      it 'returns drivers sorted by total mileage' do
        expect(@driver_history.report).to eq @driver_2_report + @driver_1_report 
      end
    end
  end

  describe('#process') do
    before(:each) do
      @data = ['Driver Alex',
        'driver Bob',
        'Trip Dan 07:15 07:45 17.3',
        'Driver Dan',
        'Driver ',
        'Trip Dan 06:12 06:32 21.8',
        'trip Alex 12:01 13:16 42.0',
        'Trip Dan 18:05 19:05 110',
        'Trip Alex   10',
        'Trip John 10:10 14:30 32.3',
        'extra']
      @output = @driver_history.process(@data)
    end
    it 'rejects invalid entries' do
      expect(@driver_history.rejected_entries.flatten.sort).to eq ['Driver ',
        'Trip Dan 18:05 19:05 110',
        'Trip Alex   10',
        'Trip John 10:10 14:30 32.3',
        'extra'].sort      
    end
    it 'returns drivers sorted by total mileage' do
      expect(@output).to eq "Alex: 42 miles @ 34 mph\nDan: 39 miles @ 47 mph\nBob: 0 miles\n"
    end
  end
end