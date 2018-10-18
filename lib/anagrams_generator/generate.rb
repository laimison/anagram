require 'json'
require 'mixlib/shellout'

module AnagramsGenerator
  class Generate
    def initialize
      puts 'Initializing AnagramsGenerator'
      
      # This file must exists as data source for this application
      @word_list_file = "lib/anagrams_generator/word_list.txt"
      
      # These files are created by this class
      @word_list_file_sorted = "lib/anagrams_generator/word_list_sorted.txt"
      @word_list_file_json = "lib/anagrams_generator/word_list.json"
    end
    
    def shell_out(cmd)
      so = Mixlib::ShellOut.new(cmd, timeout: 300)
      so.run_command
      so
    end
    
    def word_list_create_sorted_file
      unless File.exists?(@word_list_file_sorted)
        # Faster approach using Shell on Linux than using Ruby .sort
        so_sort = shell_out("sort " + @word_list_file + " -o " + @word_list_file_sorted)

        if so_sort.stderr.chomp.empty? && so_sort.exitstatus == 0
          puts "Sorted file created successfully at " + @word_list_file_sorted
        else
          puts so_sort.stderr
          puts 'Warning. Sorting was not successful. The issue with "sort" command. Using alternative way with Ruby tools ...'

          file_sorted_array = File.readlines(@word_list_file).sort
          File.open(@word_list_file_sorted,'w') do |file|
            file.puts file_sorted_array
          end
          
          puts "Sorted file created successfully at " + @word_list_file_sorted
        end
      end
    end
    
    def word_list_create_json_file
      unless File.exists?(@word_list_file_json)
        # Read file
        word_list_file = File.read(@word_list_file_sorted)

        # Create hash which will be final one for anagram queries
        word_list_hash = Hash.new

        # Going through sorted word list file
        word_list_file.each_line do |line|
          # I need sorted word and original phrase from this line
          word_sorted = line.chomp.chars.sort(&:casecmp).join
          word_original = line.chomp

          # Create key + anagrams array per word
          word_list_hash[word_sorted] ||= []

          # Add anagram word if not already added
          unless word_list_hash[word_sorted].include?(word_original)
            word_list_hash[word_sorted] << word_original
          end
        end

        # Generate word_list.json so this file contains anagrams for word that visitor is expected to look at!
        File.open(@word_list_file_json,"w") do |f|
          f.write(word_list_hash.to_json)
        end
        
        puts "JSON file created successfully at " + @word_list_file_json
      end
    end
    
    def word_list_load_hash_from_json_file
      if File.exists?(@word_list_file_json)
        json_file = File.read(@word_list_file_json)
        @word_list_hash = JSON.parse(json_file)
      end
      puts "Word list with anagrams loaded successfully"
    end
    
    def word_list_get_anagrams(*words_asked)
      # Usual work to get anagrams
      answer = Hash.new

      words_asked.flatten.each do |word_asked|
        answer[word_asked] ||= []

        # Sorted word
        word_asked_sorted = word_asked.chars.sort(&:casecmp).join

        if @word_list_hash[word_asked_sorted].nil?
          answer[word_asked] << [] 
        else
          # Delete word which is the same as key
          @word_list_hash[word_asked_sorted].delete(word_asked)

          answer[word_asked] << @word_list_hash[word_asked_sorted]
        end

        answer[word_asked] = answer[word_asked].flatten
      end

      answer
    end
  end
end