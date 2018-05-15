Rails.application.routes.draw do
  devise_for :users
  root 'projects#index'
  resources :projects, shallow: true do
    resources :chapters
  end
  resources :users, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
