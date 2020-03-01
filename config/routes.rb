Rails.application.routes.draw do

  root to: 'questions#index'
  devise_for :users

  concern :votable do
    member do
      patch :vote
    end
  end


  resources :attachments, only: :destroy

  resources :questions do
    resources :answers do
      member do
        patch :best
      end
    end
  end

  resources :questions, concerns: [:votable]
  resources :answers, concerns: [:votable]

end
