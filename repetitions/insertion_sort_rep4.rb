# description: Insertion consumes one element from the input list on each iteration, and grows a sorted output list. Each iteration, insertion sort removes one element from the input data, finds the location it belongs within the sorted list, and inserts it there. It repeats until no input elements remain.

# we want to do this in place, however, sorting the list from left to right

def insertion_sort(array)
  for index in (1...array.size)
    stored = array[index]

    while index > 0 && array[index - 1] > stored
      array[index] = array[index - 1]
      index -= 1
    end

    array[index] = stored
  end

  array
end

p insertion_sort([])
p insertion_sort([1])
p insertion_sort([5, 7, 10, 4])
