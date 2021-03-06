Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[index show] do
    resource :upgrade, only: %i[update destroy]
  end

  resources :courses do
    resources :students, only: %i[index create]
    resources :lectures, except: :index
    resources :tasks, except: :index do
      resources :solutions, controller: :task_solutions, only: %i[index create]
    end
  end

  resources :categories
  resources :solutions, only: %i[show edit update destroy]
  resources :upgrades, only: :create

  root 'pages#home'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
