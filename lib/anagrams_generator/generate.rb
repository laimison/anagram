# lib/anagrams_generator/generate.rb
module AnagramsGenerator
  class Generate
    def initialize
      puts 'Initializing AnagramsGenerator::Generate'
      @myhash = { "this_is_my_big_hash_loaded_at_startup_if_initializers_called_this": "" }
    end
    
    def use_word_list
      puts 'Executing use_word_list - in this case I call this from controller'
      @myhash
    end
  end
end