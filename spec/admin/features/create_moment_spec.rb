require 'features_helper'

feature 'Creates a moment', js: true do
  after { database_clean }
  given(:create_gandhi) { create :person, name: 'Gandhi' }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user creates a moment with an existent person', vcr: true do
    step 'GIVEN an existent person called Gandhi'
    gandhi = create_gandhi

    step 'AND I Visit the creating page'
    visit Admin.routes.new_moment_path

    step 'AND I change the person to Picasso'
    select_from_dropdown gandhi.name, from: '.people'

    step 'AND I set Date Begin'
    set_input_value '1000-1-1', from: "input[name='moment[date_begin]']"

    step 'AND I set Date End'
    set_input_value '1100-1-1', from: "input[name='moment[date_end]']"

    step 'AND I change the location address'
    set_input_value 'Paris, France', from: "input[name='moment[locations][address]']"

    step 'WHEN I click on Create button'
    click_on 'Create'
    sleep 3

    step 'THEN moment is create with the new person'
    created_moment = MomentRepository.new.all.last
    expect(created_moment.person_id).to eq gandhi.id

    step 'AND moment is create with the new date begin'
    expect(created_moment.date_begin).to eq Date.new(1000, 1, 1)

    step 'AND moment is create with the new date end'
    expect(created_moment.date_end).to eq Date.new(1100, 1, 1)

    step "AND moment's location is created with the new address"
    locations = LocationRepository.new.by_moment created_moment
    expect(locations.count).to eq 1
    expect(locations.first.address).to eq 'Paris, France'

    step 'AND the earliest_date of the associated person is updated'
    person = PersonRepository.new.find gandhi.id
    expect(person.earliest_date).to eq created_moment.date_begin
  end
end
