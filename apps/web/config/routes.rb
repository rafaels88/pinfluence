# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage
get '/about', to: 'about#index', as: :about
get '/', to: 'home#index', as: :home
