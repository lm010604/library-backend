Rails.application.routes.draw do
  root "books#index"

  resources :books, only: [ :index, :show ] do
    resources :reviews, only: [ :create, :update, :destroy ]      # login required
    member do
      post   :add_to_library                            # login required
      delete :remove_from_library                       # login required
    end
    collection do
      get :favorites
      get :more_favorites
    end
  end

  get "my/reviews", to: "reviews#index", as: :my_reviews

  resources :reviews, only: [ :show ] do
    resource :like, only: [ :create, :destroy ], controller: "review_likes"
    resources :comments, only: [ :create, :destroy ]
  end

  resources :library_entries, only: [ :index ] do
    member { patch :toggle_status }
  end

  resources :users,   only: [ :new, :create ]
  get   "profile", to: "profiles#edit", as: :profile
  patch "profile", to: "profiles#update"
  resource :session, only: [ :new, :create, :destroy ]

  resource :favorite_categories, only: [ :edit, :update ]
end
