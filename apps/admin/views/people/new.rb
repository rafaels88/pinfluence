module Admin::Views::People
  class New
    include Admin::View

    def form
      Form.new(:person, routes.people_path, person: person)
    end

    def submit_label
      'Create'
    end
  end
end
