#!/bin/bash

echo "I understand this script and I want to create a fresh Rails API in ${PWD} from ${USER} user, to proceed press enter"
read

if ls | grep -q [a-zA-Z]
then
  echo "Unsuccessful. You have some files in this directory, please remove all if you want to create Rails API"
else
  echo "gem 'rails', '~> 5.1.6'" >> Gemfile
  touch Gemfile.lock

  bundle exec rails new . --api --force --skip-bundle

  mkdir -p app/controllers/api/v1
  mkdir lib/anagram

  echo "Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: 'api' do
    namespace :v1 do
      resources :anagrams, only: [:index, :show]
    end
  end
end" > config/routes.rb

  echo "module Api::V1
  class AnagramsController < ApplicationController

    # GET /v1/anagrams
    def index
      render json: \"index block, params: #{params}\"
    end

    # GET /v1/anagrams/{id}
    def show
      render json: \"show block, params: #{params}\"
    end

  end
end" > app/controllers/api/v1/anagrams_controller.rb

  printf "\n# Run Shell command\ngem 'mixlib-shellout'\n" >> Gemfile

  bundle install
  rails db:migrate
fi
