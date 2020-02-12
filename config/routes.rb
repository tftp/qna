Rails.application.routes.draw do

  root to: 'questions#index'
  devise_for :users

  delete '/questions/:id/files/:files', to: 'questions#delete_file', as: 'delete_file_question'
  delete '/answers/:id/files/:files', to: 'answers#delete_file', as: 'delete_file_answer'

  resources :questions do
    resources :answers do
      member do
        patch :best
      end
    end
  end
end
