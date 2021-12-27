Rails.application.routes.draw do
  root 'urls#new'
  resources 'urls', only: %i[new create]
  get '/urls/:key', to: 'urls#show', as: :url
  get '/:key', to: 'urls#redirect'
  delete '/:key', to: 'urls#destroy', as: :destroy_url

end
