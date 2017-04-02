def anagrams(words)
  anagrams = Hash.new { |hash, key| hash[key] = [] }
  words.each { |word| anagrams[word.chars.sort.join] << word }
  anagrams.map { |_, list| list }.select { |list| list.size > 1 }
end

words =  ['demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live',
          'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide',
          'flow', 'neon', 'blue', 'green']

p anagrams(words)
# [["demo", "dome", "mode"], ["none", "neon"], ["tied", "diet", "edit", "tide"],
# ["evil", "live", "veil", "vile"], ["fowl", "wolf", "flow"]]
