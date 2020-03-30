Rails.application.routes.draw do
  resources :profiles
  resources :favourites
  resources :comments
  resources :snippets
  resources :about
  devise_for :users
  get 'home/index'
  get '/signedinuserprofile' => 'profiles#signedinuserprofile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'profiles#signedinuserprofile'
  root :to => 'profiles#signedinuserprofile'
  
end
