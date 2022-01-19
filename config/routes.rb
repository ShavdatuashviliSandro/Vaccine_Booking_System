Rails.application.routes.draw do
  devise_for :users

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
  end


  root to: "main#index"

  match 'bookings/:vaccine', to: 'main#current_step', via: :get, as: :current_step
  match 'next_step', to: 'main#next_step', via: :post

end
