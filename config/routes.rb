Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i(index show) do
    member do
      patch 'upgrade' => 'upgrades#update'
      delete 'upgrade' => 'upgrades#destroy'
    end
  end

  resources :courses do
    resources :students, only: %i(index create)
    resources :lectures
    resources :tasks do
      resources :solutions, controller: :task_solutions, only: :index
    end
  end

  resources :categories
  resources :solutions, only: %i(show edit create update destroy)
  resources :upgrades, only: :create

  root 'pages#home'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
