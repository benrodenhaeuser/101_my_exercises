# check if given array contains a duplicate value

def has_duplicate?(array)
  already_seen = Hash.new { |hash, key| hash[key] = false }
  array.each do |elem|
    return true if already_seen[elem]
    already_seen[elem] = true
  end
  false
end

p has_duplicate?([1, 2, 3, 4, 5]) == false
p has_duplicate?([1, 2, 3, 4, 5, 4]) == true
p has_duplicate?([]) == false
