Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[index show] do
    resource :upgrade, only: %i[update destroy]
  end

  resources :courses do
    resources :students, only: %i[index create]
    resources :lectures, except: :index
    resources :tasks do
      resources :solutions, controller: :task_solutions, only: %i[index create]
    end
  end

  resources :categories
  resources :solutions, only: %i[show edit update destroy]
  resources :upgrades, only: :create

  root 'pages#home'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
