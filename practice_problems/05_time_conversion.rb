# Write a method that will take in a number of minutes, and returns a
# string that formats the number into `hours:minutes`.
#
# Difficulty: easy.

=begin

approach:
the number of hours is minutes / 60
the number of remaining minutes is minutes % 60

=end

# obvious solution
def time_conversion(minutes)
  hours = minutes / 60
  remaining_minutes = minutes % 60
  "%s:%02d" % [hours, remaining_minutes]
end


puts("\nTests for #time_conversion")
puts("===============================================")
    puts('time_conversion(15) == "0:15": ' + (time_conversion(15)).to_s)
    puts('time_conversion(150) == "2:30": ' + (time_conversion(150)).to_s)
    puts('time_conversion(360) == "6:00": ' + (time_conversion(360)).to_s)
    puts('time_conversion(15) == "0:15": ' + (time_conversion(15) == '0:15').to_s)
    puts('time_conversion(150) == "2:30": ' + (time_conversion(150) == '2:30').to_s)
    puts('time_conversion(360) == "6:00": ' + (time_conversion(360) == '6:00').to_s)
puts("===============================================")

puts time_conversion(150)
puts time_conversion(360)
