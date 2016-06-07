# Configure your routes here
# See: http://www.rubydoc.info/gems/hanami-router/#Usage
resources :influencers, only: [:new, :index, :create]
