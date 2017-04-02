words =  ['demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live',
          'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide',
          'flow', 'neon', 'blue', 'green']

def anagrams(words)
  anagrams = Hash.new { |hash, key| hash[key] = [] }
  words.each do |word|
    anagrams[word.split("").sort.join] << word
  end
  anagrams.map { |key, value| value }.select { |list| list.size > 1 }
end

p anagrams(words)
