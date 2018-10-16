Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: 'api' do
    namespace :v1 do
      resources :anagrams, only: [:index, :show]
    end
  end

  get '*other', to: 'static#index'
end
