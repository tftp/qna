Rails.application.routes.draw do

  root to: 'questions#index'
  devise_for :users

  delete '/questions/:id/files/:files', to: 'questions#delete_file', as: 'delete_file_question'

  resources :questions do
#    delete :delete_file, on: :member
    resources :answers do
      member do
        patch :best
      end
    end
  end
end
