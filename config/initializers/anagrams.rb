# config/initializers/anagrams.rb
puts 'Loading custom library AnagramsGenerator on startup'
MyAnagram = AnagramsGenerator::Generate.new()