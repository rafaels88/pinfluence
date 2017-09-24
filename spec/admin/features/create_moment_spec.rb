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

    step 'AND I set Year Begin'
    set_input_value '1000', from: "input[name='moment[year_begin]']"

    step 'AND I set Year End'
    set_input_value '1100', from: "input[name='moment[year_end]']"

    step 'AND I change the location address'
    set_input_value 'Paris, France', from: "input[name='moment[locations][address]']"

    step 'WHEN I click on Create button'
    click_on 'Create'
    sleep 3

    step 'THEN moment is create with the new person'
    created_moment = MomentRepository.new.all.last
    expect(created_moment.person_id).to eq gandhi.id

    step 'AND moment is create with the new year begin'
    expect(created_moment.year_begin).to eq 1000

    step 'AND moment is create with the new year end'
    expect(created_moment.year_end).to eq 1100

    step "AND moment's location is created with the new address"
    locations = LocationRepository.new.by_moment created_moment
    expect(locations.count).to eq 1
    expect(locations.first.address).to eq 'Paris, France'

    step 'AND the earliest_year of the associated person is updated'
    person = PersonRepository.new.find gandhi.id
    expect(person.earliest_year).to eq created_moment.year_begin
  end
end
