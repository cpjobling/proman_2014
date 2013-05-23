Proman2014::Application.routes.draw do
  # Static pages
  match "/help", to: "static_pages#help"
  match "/about", to: "static_pages#about"
  match "/contact", to: "static_pages#contact"
  match "/tos", to: "static_pages#tos"
  match "/license", to: "static_pages#license"
  match "/thankyou", to: "static_pages#thankyou"
  match "/home", to: "static_pages#home"

  authenticated :user do
    root :to => 'home#index'
  end
  devise_scope :user do
    root :to => "devise/registrations#new"
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  devise_for :users, :controllers => { :registrations => "registrations", :confirmations => "confirmations" }
  match 'users/bulk_invite/:quantity' => 'users#bulk_invite', :via => :get, :as => :bulk_invite
  resources :users do
    get 'invite', on: :member
  end

  resources :projects
end
