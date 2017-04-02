# insertion sort works by sorting from left to right
# we take out one card from array we are sorting, working under the assumption
# that cards to the left have already been sorted.
# then we work on the elements to the left, shifting them to the right
# until we find an element that is smaller than the element we are sorting.

def insertion_sort(array)
  for index in (1...array.size)
    stored_value = array[index]
    gap = index
    while array[gap - 1] > stored_value && gap - 1 >= 0
      array[gap] = array[gap - 1]
      gap -= 1
    end
    array[gap] = stored_value
  end
  array
end

array = [10, 5, 3, 1, 2, 10]
p insertion_sort(array) # [1, 2, 3, 5, 10, 10]
