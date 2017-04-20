Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i(index show) do
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

  root 'pages#home'
end
