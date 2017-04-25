# bubble sort works by making multiple passes through the array
# we repeatedly go through the array from left to right comparing pairs of values
# if the left value is larger than the right value, we swap them
# if we do a passthrough without swaps, we are done: the array is sorted

def bubble_sort(array)
  (array.size).downto(0) do |stop_index|
    swapped = false

    (1...stop_index).each do |index|
      if array[index] < array[index - 1]
        array[index - 1], array[index] = array[index], array[index - 1]
        swapped = true
      end
    end

    break unless swapped
  end

  array
end


p array = []
bubble_sort(array)
p array == []

p array = [1]
bubble_sort(array)
p array == [1]

p array = [5, 3]
bubble_sort(array)
p array == [3, 5]

p array = [6, 2, 7, 1, 4]
bubble_sort(array)
p array == [1, 2, 4, 6, 7]

p array = %w(Sue Pete Alice Tyler Rachel Kim Bonnie)
bubble_sort(array)
p array == %w(Alice Bonnie Kim Pete Rachel Sue Tyler)
