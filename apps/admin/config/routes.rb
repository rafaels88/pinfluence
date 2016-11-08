# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
resources :moments
resources :people
resources :sessions, only: [:new, :create]
delete 'sessions', to: 'sessions#destroy', as: :session

get '/', to: "people#index", as: :home
