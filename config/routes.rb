Rails.application.routes.draw do
  root 'posts#top'

  devise_for :users
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :posts do
    get :top, :fresh, on: :collection
    member do
      put "like", to: "posts#like"
      put "favorite", to: "posts#favorite"
      put "unfavorite", to: "posts#unfavorite"
    end
  end
end
