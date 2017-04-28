require 'fileutils'

# replace whitespace with underscore, remove surrounding slashes (if any)
def normalize str
  str = str.split(" ").join("_") # replace whitespace with "_"
  str[0] = "" if str.start_with?("/") # remove leading "/"; could also be done with string.slice!(0)
  str.chop! if str.end_with?("/") # remove trailing "/"
  str
end

# create directory `directory` in pwd, and put empty file `filename` in it
def create_file(filename, directory)
  directory = normalize(directory)
  dir_path = "./#{directory}/"
  file_path = "#{dir_path}#{filename}"
  FileUtils.mkpath(dir_path) unless Dir.exist?(dir_path)
  file = File.open(file_path, "w") unless File.exist?(file_path)
  file.close
end

# example useage: number_of_files = 10, directory = "documentation"
# creates 10 files in directory documentation
# with filenames 01.rb to 10.rb
def create_exercise_files(number_of_files, directory)
  for i in (1..number_of_files)
    if i < 10
      filename = "0#{i}.rb"
    else
      filename = "#{i}.rb"
    end
    create_file(filename, directory)
  end
end

# (don't uncomment and run unless you want to create those files!)
# create_exercise_files(10, "12 Hashes")
