Rails.application.routes.draw do
  devise_for :users
  get 'profile', to: 'users#show', as: :user_profile
  root to: "pages#home"
end
