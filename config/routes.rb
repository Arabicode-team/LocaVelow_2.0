Rails.application.routes.draw do
  namespace :admin do
      resources :accessories
      resources :bicycles
      resources :rentals
      resources :reviews
      resources :users

      root to: "accessories#index"
    end
  root "bicycles#index"
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show, :edit, :update]
  resources :accessories
  resources :reviews
  get 'rentals/confirm', to: 'rentals#confirm', as: :confirm_rental
  get 'rentals/payment_success', to: 'rentals#payment_success', as: 'rental_payment_success'

  # config/routes.rb
  

  resources :rentals
  resources :bicycles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
