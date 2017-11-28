lines = File.readlines("./multiset_gem.rb")

without_comments = lines.select { |line| line[0] != "#" && line[2] != "#" }

File.open("./no_comments.rb", "w+") do |file|
  without_comments.each { |line| file.puts(line) }
end
