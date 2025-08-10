Rails.application.routes.draw do
  root "books#index"

  resources :books, only: [ :index, :show ] do
    resources :reviews, only: [ :create, :destroy ]      # login required
    member do
      post   :add_to_library                            # login required
      delete :remove_from_library                       # login required
    end
  end

  get "my/reviews", to: "reviews#index", as: :my_reviews

  resources :reviews, only: [] do
    resource :like, only: [ :create, :destroy ], controller: "review_likes"
  end

  resources :library_entries, only: [ :index ] do
    member { patch :toggle_status }                     # read <-> not_read_yet
  end

  resources :users,   only: [ :new, :create ]
  resource  :session, only: [ :new, :create, :destroy ]
end
