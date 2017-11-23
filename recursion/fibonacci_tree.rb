# fibo_tree returns a string visualizing the binary-tree-like structure of the nested calls to the fibonacci method

# fibonacci tree
def fibo_tree(number, depth=0)
  if number < 2
    "f(#{number}) = #{fibonacci(number)}"
  else
    indent = indent_string(depth)
    "f(#{number}) = #{fibonacci(number)}\n#{indent}#{fibo_tree(number-1,depth+1)}\n#{indent}#{fibo_tree(number-2,depth+1)}"
  end
end

# method to build the "indent string", depending on the nesting depth of recursive function calls
def indent_string(depth)
  indent_level = (depth + 1) * 2
  counter = indent_level
  indent = ""
  while counter != 0
    if counter % 2 == 1
      indent << "  "
    else
      if indent == "" # we are still at the very left
        indent << " "
      else
        indent << "|"
      end
    end
    counter -= 1
  end
  indent
end

# the fibonacci method itself
def fibonacci(number)
  if number < 2
    number
  else
    fibonacci(number - 1) + fibonacci(number - 2)
  end
end

puts fibo_tree(6)
