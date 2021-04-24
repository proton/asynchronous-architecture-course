Rails.application.routes.draw do
  root to: 'accounts#index'

  get '/my', to: 'accounts#my'
end
