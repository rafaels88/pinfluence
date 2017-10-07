require 'features_helper'

feature 'Updates a person', js: true do
  after { database_clean }
  given(:create_gandhi) { create :person, name: 'Gandhi' }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user updates a person', vcr: true do
    step 'GIVEN an existent person called Gandhi'
    gandhi = create_gandhi

    step 'AND Visit the edit page of this Person'
    visit Admin.routes.edit_person_path(gandhi.id)

    step 'GIVEN I change the Name'
    set_input_value 'Rosa Parks', from: "input[name='person[name]']"

    step 'AND I change the Gender'
    select_from_dropdown 'Female', from: '.gender'

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 3

    step 'THEN person is updated'
    created_person = PersonRepository.new.all.last
    expect(created_person.name).to eq 'Rosa Parks'
    expect(created_person.gender).to eq 'female'
    expect(created_person.type).to eq :person
  end
end
