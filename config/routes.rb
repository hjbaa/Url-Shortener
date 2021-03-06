# frozen_string_literal: true

Rails.application.routes.draw do
  root 'urls#new'
  get '/urls/:key', to: 'urls#show', as: :url
  resource :session, only: %i[new create destroy]

  resources :urls, only: %i[new create]
  resources :users, only: %i[new create edit update show]

  namespace :admin do
    resources :users, only: %i[index create edit update destroy]
    resources :urls, only: %i[index create destroy]
  end

  get '/:key', to: 'urls#redirect'
  delete '/:key', to: 'urls#destroy', as: :destroy_url
end
