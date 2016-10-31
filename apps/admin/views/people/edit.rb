module Admin::Views::People
  class Edit
    include Admin::View

    def form
      Form.new(:person, routes.people_path,
               { person: person }, { method: :patch })
    end

    def submit_label
      'Update'
    end
  end
end
