module ApiGraphql::Controllers::Api
  class Create
    include ApiGraphql::Action

    def call(params)
      self.body = JSON.generate schema_body(params[:query])
    end

    private

    def schema_body(query)
      PersonSchema.execute(query)
    end
  end
end
