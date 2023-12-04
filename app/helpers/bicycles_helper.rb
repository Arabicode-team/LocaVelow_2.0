module BicyclesHelper
    def group_reserved_intervals(rentals, date)
        intervals = []
        current_interval = nil
      
        (0..23).each do |hour|
          start_time = date.beginning_of_day + hour.hours
          end_time = start_time + 1.hour
          rental = rentals.find { |r| r.start_date <= end_time && r.end_date >= start_time }
      
          if rental
            if current_interval && current_interval[:end] == start_time
              current_interval[:end] = end_time
            else
              current_interval = { start: start_time, end: end_time }
              intervals << current_interval
            end
          else
            current_interval = nil
          end
        end
      
        intervals
      end
      
end