# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/moments/years', to: 'moment_years#index', as: :moment_years
resources :moments, only: [:index]
