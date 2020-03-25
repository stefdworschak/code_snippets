Rails.application.routes.draw do
  resources :profiles
  resources :favourites
  resources :comments
  resources :snippets
  devise_for :users
  get 'home/index'
  get '/signedinuserprofile' => 'profiles#signedinuserprofile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  root :to => 'home#index'
  
end
