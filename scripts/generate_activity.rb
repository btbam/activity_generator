Dir["./services/*.rb"].each { |file| require file }

input_array = ARGV

generator = StartActivity.new(input_file: input_array[0],
                              output_file: input_array[1])
generator.run
