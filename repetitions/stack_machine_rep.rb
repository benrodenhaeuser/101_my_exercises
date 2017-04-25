=begin

TASK DESCRIPTION

Stack Data Structure: Array that just uses push and pop
Stack-and-register programming language: Language whose instructions
manipulate a stack and a register ("current value")

operation with two arguments:
  - pop from stack
  - perform operation with popped value and register value
  - store result back in the register

stack-and-register based programming language:

- n (place value in the register, do not modify stack)
- PUSH (push register value on to the stack. leave value in register)
- ADD (pop value from stack and add it to register, store in register)
- SUB
- MULT
- DIV
- MOD
- POP (pop value from stack and place in register)
- PRINT (print value in register)

A program is a string such as '5 PUSH 3 MULT PRINT'.
Register should be initialized to 0.

APPROACH

- Stack is modeled as array
- Register is an integer
- Perhaps we could have a hash `machine`, i.e.,
    machine[:stack] is an array
    machine[:register] is an integer
- What happens as the machine receives instructions?
  - We have to parse the instructions:
    i.e., split the string into an array (delimiter: ' ')
  - We have to run the instructions one by one (i.e., a loop):
    - if the current instruction is an integer, call the `place` method
    - if it is ADD, call the `add` method
    - if it is SUB, call the `sub` method
    - and so on.
  - each of these methods takes a single argument: the `machine` hash.
  - for the implementation of the instruction methods, use the task description above
  - we could have another hash that converts the instructions to symbols, and then use `send` method
  - i.e., send(INST_TO_SYM[ADD])
  - case that instruction is integer has to be handled separately

=end

def minilang(commands)
  machine = { stack: [], register: 0 }
  commands.split(' ').each { |command| run(command, machine) }
end

def run(command, machine)
  if command.to_i.to_s == command
    write_to_register(command.to_i, machine)
  else
    send(command.downcase, machine)
  end
end

def write_to_register(value, machine)
  machine[:register] = value
end

def push(machine)
  machine[:stack] << machine[:register]
end

def add(machine)
  machine[:register] += machine[:stack].pop
end

def sub(machine)
  machine[:register] -= machine[:stack].pop
end

def mult(machine)
  machine[:register] *= machine[:stack].pop
end

def div(machine)
  machine[:register] /= machine[:stack].pop
end

def mod(machine)
  machine[:register] %= machine[:stack].pop
end

def pop(machine)
  machine[:register] = machine[:stack].pop
end

def print(machine)
  puts machine[:register]
end

# examples

minilang('PRINT')
# 0

minilang('5 PUSH 3 MULT PRINT')
# 15

minilang('5 PRINT PUSH 3 PRINT ADD PRINT')
# 5
# 3
# 8

minilang('5 PUSH POP PRINT')
# 5

minilang('3 PUSH 4 PUSH 5 PUSH PRINT ADD PRINT POP PRINT ADD PRINT')
# 5
# 10
# 4
# 7

minilang('3 PUSH PUSH 7 DIV MULT PRINT ')
# 6

minilang('4 PUSH PUSH 7 MOD MULT PRINT ')
# 12

minilang('-3 PUSH 5 SUB PRINT')
# 8

minilang('6 PUSH')
# (nothing printed; no PRINT commands)
