require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

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
    member do
      patch :subscribe
    end
  end

  resources :questions, concerns: %i[votable commentable]
  resources :answers, concerns: %i[votable commentable]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers
      end
    end
  end

end
