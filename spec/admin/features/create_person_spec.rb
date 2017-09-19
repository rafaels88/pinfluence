require 'features_helper'

feature 'Creates a person', js: true do
  after { database_clean }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user creates a person', vcr: true do
    step 'Visit the creating page of Person'
    visit Admin.routes.new_person_path

    step 'GIVEN I set Name'
    set_input_value 'Marie Curie', from: "input[name='person[name]']"

    step 'AND I set Gender'
    select_from_dropdown 'Female', from: '.gender'

    step 'WHEN I click on Create button'
    click_on 'Create'
    sleep 2

    step 'THEN person is create'
    created_person = PersonRepository.new.all.last
    expect(created_person.name).to eq 'Marie Curie'
    expect(created_person.gender).to eq 'female'
    expect(created_person.type).to eq :person
  end
end
