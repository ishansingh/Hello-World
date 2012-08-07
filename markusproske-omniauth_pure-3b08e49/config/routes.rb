OmniauthDemo::Application.routes.draw do

  resources :old_twits

  # Omniauth pure
  match "/signin" => "services#signin"
  match "/signout" => "services#signout"

  match '/auth/:service/callback' => 'services#create' 
  match '/auth/failure' => 'services#failure'
  match '/services/facebook_redirect' => 'services#facebook_redirect'
  match '/services/facebook_getCode' => 'services#facebook_getCode'
  match '/services/test' => 'services#test'
  match '/auth/instagram' => 'services#insta_index'
  match '/in/icallback' => 'services#icallback'

  get "posts/new"
  post "posts" => "services#post"

  resources :services, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end

  # used for the demo application only
  resources :users, :only => [:index] do
    collection do
      get 'test'
    end
  end
   
  root :to => "users#index"
end
