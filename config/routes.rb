Proman2014::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  devise_scope :user do
    root :to => "devise/registrations#new"
  end
  root :to => "home#index"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users
end