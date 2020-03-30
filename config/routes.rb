Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      patch :vote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end


  resources :attachments, only: :destroy

  resources :questions do
    resources :answers do
      member do
        patch :best
      end
    end
  end

  resources :questions, concerns: %i[votable commentable]
  resources :answers, concerns: %i[votable commentable]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show] do
        resources :answers, only: [:index]
      end
    end
  end

end
