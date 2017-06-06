# recall the following: 
# bubble sort works by making multiple passes through the array.
# on each pass, we compare every pair of elements and swap it if needed.
# bubble sort terminates if a pass has produced no swaps (in which case the array is sorted!)

=begin

- set variable swapped to true
- while swapped:
  - **set swapped to false**
  - loop over array starting with second element (index i):
    - if array[i-1] > array[i]
        - swap the two of them
        - set swapped to true

- auxiliary method swap:
  - given an array and two indices index1 and index2
  - store value at index1 in variable temp
  - assign value at index2 to array[index1]
  - assigne temp to array[index2]

=end

def swap(index1, index2, array)
  temp = array[index1]
  array[index1] = array[index2]
  array[index2] = temp
end

def bubble_sort(array)
  swapped = true
  while swapped
    swapped = false
    for index in (1...array.size)
      if array[index - 1] > array[index]
        swap(index, index - 1, array)
        swapped = true
      end
    end
  end
  array
end

p bubble_sort([]) # []
p bubble_sort([1]) # [1]
p bubble_sort([3, 0, 10, 2, 3]) # [0, 2, 3, 3, 10]
