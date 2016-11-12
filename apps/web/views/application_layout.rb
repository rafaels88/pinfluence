module Web
  module Views
    class ApplicationLayout
      include Web::Layout

      def production?
        Hanami.env == 'production'
      end

      def gmaps_tag; end

      def moments_api_url; end

      def years_api_url; end
    end
  end
end
