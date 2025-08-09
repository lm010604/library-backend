Rails.application.routes.draw do
  root "books#index"

  resources :books do
    member do
      patch :toggle_read
    end
  end

  resources :users, only: [ :new, :create ]
  resource  :session, only: [ :new, :create, :destroy ]
end
