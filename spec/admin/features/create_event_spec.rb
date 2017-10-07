require 'features_helper'

feature 'Creates a event', js: true do
  after { database_clean }

  background do
    sign_in_on_dashboard
    visit Admin.routes.new_event_path
  end

  scenario 'Admin user creates a event', vcr: true do
    step 'GIVEN I set a Name'
    set_input_value 'Second World War', from: "input[name='event[name]']"

    step 'WHEN I click on Create button'
    click_on 'Create'
    sleep 2

    step 'THEN event is create'
    created_event = EventRepository.new.last
    expect(created_event.name).to eq 'Second World War'
    expect(created_event.type).to eq :event
  end

  scenario 'Admin user creates an event with a new moment', vcr: true do
    step 'GIVEN I set a Name'
    set_input_value 'Second World War', from: "input[name='event[name]']"

    step 'AND I set a Date Begin for a new moment'
    set_input_value '1000-1-1', from: "input[name='event[moments][][date_begin]'][value='']"

    step 'AND I set a Date End for a new moment'
    set_input_value '1100-5-10', from: "input[name='event[moments][][date_end]'][value='']"

    step 'WHEN I click on Create button'
    click_on 'Create'
    sleep 2

    step 'THEN event is created'
    created_event = EventRepository.new.last
    expect(created_event.name).to eq 'Second World War'
    expect(created_event.type).to eq :event
    expect(created_event.earliest_date).to eq Date.new(1000, 1, 1)

    step 'AND the new moment is created'
    created_moment = MomentRepository.new.last
    expect(created_moment.date_begin).to eq Date.new(1000, 1, 1)
    expect(created_moment.date_end).to eq Date.new(1100, 5, 10)
    expect(created_moment.event_id).to eq created_event.id
    expect(created_moment.person_id).to be_nil
  end
end
