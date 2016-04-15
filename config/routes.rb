Rails.application.routes.draw do
  resources :sessions, only: %i(new create destroy)
  resources :users do
    member do
      patch 'upgrade' => 'upgrades#update'
      delete 'upgrade' => 'upgrades#destroy'
    end
  end
  resources :courses do
    member { get :students }
    resources :lectures
    resources :tasks do
      member { get :solutions }
    end
  end
  resources :categories
  resources :enrollments, only: :create
  resources :solutions, only: %i(show edit create update destroy)
  resources :upgrades, only: :create

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  delete 'signout' => 'sessions#destroy'

  root 'pages#home'
end
