# insertion sort: basic idea

# the basic idea is to sort "from left to right", ensuring that successively
# larger chunks of the array are "already sorted".
# initially, the array consisting just of the first element is already sorted
# now let's create a two-element array that is already sorted using the second
# element. then, a three-element array that is already sorted using the third
# element. and so on.

# so we basically have one outer iteration which we can do with each
# and inside, there is a while loop which takes care of the insertion.

# insertion sort: implementation

def insertion_sort(array)
  array.each_index do |index|
    stored_value = array[index]
    gap = index # where we can write (this is just to make it clearer)
    while gap > 0 && array[gap - 1] > stored_value # while loop skipped for gap == 0
      # ^ note that we cannot use gap >= 0, because then we would have a negative gap in the end, and we would not skip first iteration!
      array[gap] = array[gap - 1]
      # overwriting gap with element from the left, i.e.: actual sorting step happening!
      gap -= 1 # next place to write
    end
    array[gap] = stored_value
  end
  array
end


array = []
p insertion_sort(array) # []

array = [10, 7, 4, 3, 11]
p insertion_sort(array) # [3, 4, 7, 10, 11]

array = [10, 7, 10, 4, 3, 11]
p insertion_sort(array) # [3, 4, 7, 10, 10, 11]
