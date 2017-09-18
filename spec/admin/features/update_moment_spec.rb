require 'features_helper'

feature 'Updates a moment', js: true do
  after { database_clean }
  given(:create_gandhi) { create :person, name: 'Gandhi' }
  given(:create_picasso) { create :person, name: 'Picasso' }
  given(:create_moment) { create :moment, year_begin: 1000, year_end: 1050, person_id: create_gandhi.id }
  given(:create_location) { create :location, address: 'Barcelona, Spain', moment_id: create_moment.id }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user updates a moment with another existent person', vcr: true do
    step 'GIVEN an existent person called Gandhi'
    create_gandhi

    step 'GIVEN an existent person called Picasso'
    picasso = create_picasso

    step 'GIVEN a created moment for Gandhi'
    moment = create_moment

    step 'GIVEN a created location for this moment'
    location = create_location

    step 'Visit the edit page of this moment'
    visit Admin.routes.edit_moment_path(id: moment.id)

    step 'GIVEN I change the person to Picasso'
    select_from_dropdown 'Picasso', from: '.people'

    step 'GIVEN I change the location address'
    set_input_value 'Paris, France', from: "input[value='#{location.address}']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 2

    step 'THEN moment is updated with the new person'
    updated_moment = MomentRepository.new.find moment.id
    expect(updated_moment.person_id).to eq picasso.id

    step "THEN moment's location is updated with the new address"
    locations = LocationRepository.new.by_moment updated_moment
    expect(locations.count).to eq 1
    expect(locations.first.address).to eq 'Paris, France'
  end
end
