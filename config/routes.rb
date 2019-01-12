Rails.application.routes.draw do

  devise_for :users
  root 'projects#index'
  resources :projects, shallow: true do
    resources :chapters
  end
  get '/translations(/:id)', to: 'translations#create', as: :generate
  post '/phrases', to: 'phrases#update'
  resources :options
  resources :users, only: [:index, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
