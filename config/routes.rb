Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:create]

  resources :categories do
    resources :products, only: [:index]
  end

  resources :products

  resources :carts do
    resources :cart_items, only: [:index, :update, :destroy]
  end

  resources :orders do
    resources :order_items, only: [:create, :update, :destroy]

    member do
      patch :cancel
    end
  end
end
