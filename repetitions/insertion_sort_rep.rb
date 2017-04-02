# sort array in place
# loop invariant: "sorted up to current index"
# initially, the array [array[0]] is sorted, so we start at index 1

def insertion_sort(array)
  for index in (1...array.size)
    stored_value = array[index]
    gap = index # gap is the index at which we can overwrite.
    # ^ initially, it's `index` because that's what he have stored
    while gap > 0 && array[gap - 1] > stored
      array[gap] = array[gap - 1]
      gap -= 1 # now we can overwrite *this* index, having moved corresp. value to the right
    end
    array[gap] = stored_value # remember, `gap` is the index at which we can overwrite
  end
  array
end

arr = [10, 5, 3]
p insertion_sort(arr)

arr = []
p insertion_sort(arr)
