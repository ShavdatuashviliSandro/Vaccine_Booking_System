require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web => '/sidekiq'
  namespace :admin do
    root to:"main#index"
    resources :users
    resources :vaccines_items
    resources :bookings
    resources :patients
    resources :business_unit_slots
    get 'business_units/fetch_cities'
    get 'business_units/fetch_districts'
    resources :business_units
    resources :countries
    resources :cities
    resources :districts
    resources :orders
    resources :order_sms_messages
  end
  get 'slots/fetch_cities'
  get 'slots/fetch_districts'
  get 'slots/fetch_business_units'

  resources :slots, only: :index

  root to: "main#index"

  match 'bookings/:vaccine', to: 'main#current_step', via: :get, as: :current_step
  match 'next_step', to: 'main#next_step', via: :post
  match 'prev_step', to: 'main#prev_step', via: :post
  resources :order_cancellations, only: :index
  get 'order_cancellations/fetch_order_code'

  resources :order_cancellations do
    collection do
      get :create
    end
  end

  post 'order_cancellations/call'
  post 'order_cancellations/create'
end
