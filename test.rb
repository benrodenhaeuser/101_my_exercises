def foo(b)
  p b.object_id
end

a = [1, 2, 3]
p a.object_id
foo(a)
