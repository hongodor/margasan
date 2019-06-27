Rails.application.routes.draw do

  devise_for :users, skip: [:sessions], controllers: { registrations: 'registrations' }
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  root 'projects#index'
  resources :projects, shallow: true do
    resources :chapters
  end
  get '/translations/:id', to: 'translations#create', as: :generate
  put '/phrases/:id', to: 'phrases#update'

  resources :options
  resources :users, only: [:index, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
