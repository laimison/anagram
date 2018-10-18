puts 'Loading custom library AnagramsGenerator on startup and memory for fast access'
MyAnagram = AnagramsGenerator::Generate.new

# It creates txt and json files only if they don't exist so Rails is loading faster from second time (first time should take up to 10 seconds for 4 MB file)
# - consider to generate and place the files before Rails starting or by copying them by any suitable method if word list file becomes bigger
MyAnagram.word_list_create_sorted_file
MyAnagram.word_list_create_json_file

# It loads hash everytime when Rails started (takes upto 2 seconds for 4 MB file)
# - consider Redis or other cache server for better performance and data management in memory if hash becomes bigger
MyAnagram.word_list_load_hash_from_json_file
