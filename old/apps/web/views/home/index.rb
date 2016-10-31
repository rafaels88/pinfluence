module Web::Views::Home
  class Index
    include Web::View

    def production?
      Hanami.env == 'production'
    end
  end
end
