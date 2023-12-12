Rails.application.routes.draw do
  get 'static/terms_and_conditions'
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
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :accessories
  resources :reviews
  get 'rentals/confirm', to: 'rentals#confirm', as: :confirm_rental
  get 'rentals/payment_success', to: 'rentals#payment_success', as: 'rental_payment_success'

  resources :rentals
  resources :bicycles

  #route for gem letter_opener for emails in dev environment
  get 'terms_and_conditions', to: 'static#terms_and_conditions'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
