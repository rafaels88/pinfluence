module Web
  module Views
    class ApplicationLayout
      include Web::Layout

      def production?
        Hanami.env == 'production'
      end
    end
  end
end
