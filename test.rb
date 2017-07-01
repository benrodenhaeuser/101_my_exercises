MESSAGES = { 'greeting' => 'Hello %{name}' }


puts MESSAGES['greeting'] % { name: 'Ben' }

# puts "this is a %{var1} from %{var2}" % { var1: 'message', var2: 'ben'}
