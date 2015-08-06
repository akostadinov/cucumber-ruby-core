require 'cucumber/core/filter'

module Cucumber
  module Core
    module Test

      # Sorts and filters scenarios based on a list of locations
      class LocationsFilter < Filter.new(:locations)

        def test_case(test_case)
          Kernel.puts(test_case.name)
          possible_locations_index = []
          possible_locations = []
          locations.each_with_index{ |l, i| l.file == test_case.location.file && possible_locations << l && possible_locations_index << i }
          idx = test_case.matching_location_index(possible_locations)
          if idx
            test_cases[possible_locations_index[idx]] << test_case
          end
          self
        end

        def done
          sorted_test_cases.each do |test_case|
            test_case.describe_to receiver
          end
          receiver.done
          self
        end

        private

        def sorted_test_cases
          test_cases.flatten
        end

        def test_cases
          @test_cases ||= locations.map {[]}
        end

      end
    end
  end
end
