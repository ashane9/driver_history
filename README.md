## Driver History
For reporting the total mileage and average mph for set of drivers.

The approach was to build this application in Ruby without the use of an ORM.
There are 3 classes: 
  1. `DrivingHistoryTracker`
      - processes the input data 
          - registering drivers
          - recording trips
          - rejecting invalid entries
      - maintains the list of registered drivers
      - reports the full list of drivers sorted by highest total mileage
  2) `Driver`
      - stores driver's name
      - maintains the list of trips belonging to the driver
      - calculates the total mileage
      - calculates the total time traveled
      - calculates the average miles per hour
      - reports the total mileage and average mph for the driver
  3) `Trip`
      - stores the start time, stop time, and miles for the trip
      - calculates the time difference between stop and start
      - calculates the miles per hour for the trip
      - checks if mph is <= 5 or >= 100

I chose to go with objects in order to create a visual understanding of the code and to allow the single object to preform the necessary tasks that are related to that object. By having that object be responsible for these tasks, it prevents having to pass around a data structure. There is the added benefit of creating function names that describe exactly what action it is performing.  For example, I can say `Trip.new('10:10','15:30','30.5').miles_per_hour` and be confident I am getting the mph for that particular trip.

## Usage
To execute the script:

`ruby bin\report_driving_history.rb input.txt [-o]` 

or 

`cat input.txt | ruby bin\report_driving_history.rb`

-o is an optional command to output the results to a file instead of displaying in the terminal. results.txt is the default output file name but this can be overwritten by passing the desired name after `-o`

## Installation
The 3 gems (`rspec`,`faker`,`factory_bot`) in the `Gemfile` are only required for the specs.

run `bundle install` to install

## Tests
To run, execute:

    `rspec specs` 

or

    `rspec specs\driver_spec.rb`

    `rspec specs\driving_history_tracker_spec.rb`

    `rspec specs\trip_spec.rb`
  

Each spec is written to test the functionality of the corresponding class.

To test `bin\report_driving_history.rb` with an actual file, there is a sample file that can be run:

execute:

    `ruby bin\report_driving_history.rb data\process_input.txt`

or 

  To test a large data sample, execute:
  
    `ruby bin\generate_data.rb [number]` 
    
  which will generate a random set records. Pass in a number to specify the number or records. Default is set to 100. This generated file is created as `data\input.txt`


## Future Enhancements
Ideas for future enhancements would be:
1) add statistical information:
    - number of records in the input file
    - number of records rejected for an incorrect command (one that is not Driver or Trip)
    - number of records rejected for a missing attribute
    - number of Trip entries rejected for mph being out of the bounds <5 or >100
    - number of Driver entries rejected for already being registered
    - number of Trip entries not having a driver that is registered
    - number of records that were successfully processed
    - and process time 
2) process more than one file
3) generate a log file for error handling
4) output the rejected entries to a file
5) display the progress when processing large files
