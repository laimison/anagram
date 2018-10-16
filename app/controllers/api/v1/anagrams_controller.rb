# require 'mixlib/shellout'
require 'json'
require 'pp'

# def shell_out(cmd)
#   so = Mixlib::ShellOut.new(cmd, timeout: 300)
#   so.run_command
#   so
# end

def anagram(*words_asked)
  # Do I have sorted file?
  unless File.exists?('lib/anagram/word_list_sorted.txt')
    # Faster approach using Shell on Linux than using Ruby .sort
    # so_sort = shell_out('sort word_list.txt -o word_list_sorted.txt')

    # if so_sort.stderr.chomp.empty? && so_sort.exitstatus == 0
    #   puts 'Sorted successfully'
    # else
    #   puts so_sort.stderr
    #   puts 'Warning. Sorting was not successful. The issue with "sort" command. Using alternative way with Ruby tools ...'

      file_sorted_array = File.readlines('lib/anagram/word_list.txt').sort
      File.open('lib/anagram/word_list_sorted.txt','w') do |file|
        file.puts file_sorted_array
      end
    # end
  end

  unless File.exists?('lib/anagram/word_list.json')
    # Read file
    word_list_file = File.read('lib/anagram/word_list_sorted.txt')

    # Create hash which will be final one for anagram queries
    word_list_hash = Hash.new

    # Going through sorted word list file
    word_list_file.each_line do |line|
      # I need sorted word and original phrase from this line
      word_sorted = line.chomp.chars.sort(&:casecmp).join
      word_original = line.chomp

      # Create key + anagrams array per word
      word_list_hash[word_sorted] = [] unless word_list_hash[word_sorted].kind_of?(Array)

      # Add anagram word if not already added
      unless word_list_hash[word_sorted].include?(word_original)
        word_list_hash[word_sorted] << word_original
      end
    end

    # Generate word_list.json so this file contains anagrams for word that visitor is expected to look at!
    File.open("lib/anagram/word_list.json","w") do |f|
      f.write(word_list_hash.to_json)
    end
  else
    json_file = File.read('lib/anagram/word_list.json')
    word_list_hash = JSON.parse(json_file)
  end

  # Usual work to get anagrams
  answer = Hash.new

  words_asked.flatten.each do |word_asked|
    answer[word_asked] = [] unless answer[word_asked].kind_of?(Array)

    # Sorted word
    File.write('/tmp/test', word_asked)
    word_asked_sorted = word_asked.chars.sort(&:casecmp).join

    if word_list_hash[word_asked_sorted].nil?
      answer[word_asked] << [] 
    else
      # Delete word which is the same as key
      word_list_hash[word_asked_sorted].delete(word_asked)

      answer[word_asked] << word_list_hash[word_asked_sorted]
    end

    answer[word_asked] = answer[word_asked].flatten
  end

  answer
end

module Api::V1
  class AnagramsController < ApplicationController

    # GET /v1/anagrams
    def index
      words_asked = params['words'].split(',')

      answer = anagram(words_asked)
      # answer = words_asked

      render json: "#{answer}"
    end

    # GET /v1/anagrams/{id}
    def show
      render json: "show block, params: #{params}"
    end

  end
end
