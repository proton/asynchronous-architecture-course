# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :tasks do
    post :assign_all, on: :collection
    patch :complete, on: :member
  end
end
