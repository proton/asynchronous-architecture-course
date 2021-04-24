Rails.application.routes.draw do
  root to: 'accounts#index'

  resources :accounts do
    get :log, on: :member
  end

  get '/my', to: 'accounts#my'
end
