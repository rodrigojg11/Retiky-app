Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  get "/search_flights", to: "flight#search", as: :search_flights


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :tickets do
    resources :orders, only: [:create, :destroy]
    member do
      patch 'create_lightning_offer', to: 'tickets#create_lightning_offer'
      patch 'stop_lightning_offer', to: 'tickets#stop_lightning_offer'
      get :purchase_confirmation, to: 'tickets#purchase_confirmation'
    end
  end


  resources :orders, only: [:index, :show, :destroy]

  resources :users, only: [:show] do
    member do
      get 'tickets', to: 'users#tickets'
      get 'orders', to: 'users#orders'
    end
  end



  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
end
