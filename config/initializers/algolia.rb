require 'algoliasearch'

Algolia.init application_id: ENV['ALGOLIA_APPLICATION_ID'],
             api_key:        ENV['ALGOLIA_API_KEY'],
             search_timeout: 10,
             connect_timeout: 10
