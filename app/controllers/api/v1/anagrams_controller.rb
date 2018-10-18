module Api::V1
  class AnagramsController < ApplicationController
    # GET /v1/anagrams - main way to get anagrams
    def index
      if params['words'].present?
        words_asked = params['words'].split(',')

        # It gets anagrams in miliseconds (see initializers/anagram.rb and lib/anagrams_generator/generate.rb which solved that)
        anagrams_found = MyAnagram.word_list_get_anagrams(words_asked)

        logger.info "Anagrams found: #{anagrams_found}"

        render json: anagrams_found.to_s
      else
        render json: "No parameters specified or your parameter name is not 'words'"
      end
    end

    # GET /v1/anagrams/{id} - not needed for this particular application (avoid error if accessed)
    def show
      render json: "show block, params: #{params}"
    end
  end
end
