require 'features_helper'

feature 'Updates a moment', js: true do
  after { database_clean }
  given(:create_gandhi) { create :person, name: 'Gandhi' }
  given(:create_picasso) { create :person, name: 'Picasso' }
  given(:create_moment) do
    create :moment, date_begin: Date.new(1000, 1, 1), date_end: Date.new(1050, 1, 1), person_id: create_gandhi.id
  end
  given(:create_location) { create :location, address: 'Barcelona, Spain', moment_id: create_moment.id }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user updates a moment with another existent person', vcr: true do
    step 'GIVEN an existent person called Gandhi'
    create_gandhi

    step 'AND an existent person called Picasso'
    picasso = create_picasso

    step 'AND a created moment for Gandhi'
    moment = create_moment

    step 'AND a created location for this moment'
    location = create_location

    step 'AND I Visit the edit page of this moment'
    visit Admin.routes.edit_moment_path(id: moment.id)

    step 'AND I change the person to Picasso'
    select_from_dropdown 'Picasso', from: '.people'

    step 'AND I change the location address'
    set_input_value 'Paris, France', from: "input[value='#{location.address}']"

    step 'AND I change the date begin to an earlier date'
    set_input_value '500-4-10', from: "input[value='#{moment.date_begin}']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 2

    step 'THEN moment is updated with the new person'
    updated_moment = MomentRepository.new.find moment.id
    expect(updated_moment.person_id).to eq picasso.id

    step "AND moment's location is updated with the new address"
    locations = LocationRepository.new.by_moment updated_moment
    expect(locations.count).to eq 1
    expect(locations.first.address).to eq 'Paris, France'

    step "AND moment's date begin is updated with the new date"
    person = PersonRepository.new.find picasso.id
    expect(person.earliest_date).to eq updated_moment.date_begin
  end

  scenario 'Admin user updates a moment with a new person', vcr: true do
    step 'GIVEN an existent person called Gandhi'
    create_gandhi

    step 'AND a created moment for Gandhi'
    moment = create_moment

    step 'AND a created location for this moment'
    create_location

    step 'AND I Visit the edit page of this moment'
    visit Admin.routes.edit_moment_path(id: moment.id)

    step "AND I choose a new gender on the New Person's field"
    select_from_dropdown 'Female', from: '.gender'

    step 'AND I filled the field Name for the new person'
    set_input_value 'Marie Curie', from: "input[name='moment[influencer][name]']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 3

    step 'THEN moment is updated with the new person'
    updated_moment = MomentRepository.new.find moment.id
    new_person = PersonRepository.new.search_by_name('Marie Curie').first
    expect(updated_moment.person_id).to eq new_person.id

    step "AND moment's location keeps the same"
    locations = LocationRepository.new.by_moment updated_moment
    expect(locations.count).to eq 1
    expect(locations.first.address).to eq 'Barcelona, Spain'
  end
end
