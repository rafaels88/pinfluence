module Api::Controllers::MomentYears
  class Index
    include Api::Action
    expose :years

    def call(params)
      self.format = :json

      @years = MomentRepository.new.all_available_years
    end
  end
end
