require 'features_helper'

feature 'Updates a event', js: true do
  after { database_clean }
  given(:create_second_ww) { create :event, name: 'Second World War' }

  background do
    sign_in_on_dashboard
  end

  scenario 'Admin user updates a event', vcr: true do
    step 'GIVEN an existent event called Second World War'
    event = create_second_ww

    step 'AND I Visit the updating page of Event'
    visit Admin.routes.edit_event_path(event.id)

    step 'AND I change the Name'
    set_input_value '2nd World War', from: "input[name='event[name]']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 2

    step 'THEN event is update'
    updated_event = EventRepository.new.last
    expect(updated_event.name).to eq '2nd World War'
    expect(updated_event.type).to eq :event
  end

  scenario 'Admin user updates an event adding a new moment', vcr: true do
    step 'GIVEN an existent event'
    event = create_second_ww

    step 'AND I Visit the updating page of Event'
    visit Admin.routes.edit_event_path(event.id)

    step 'AND I set a Date Begin for a new moment'
    set_input_value '1000-1-1', from: "input[name='event[moments][][date_begin]'][value='']"

    step 'AND I set a Date End for a new moment'
    set_input_value '1100-1-1', from: "input[name='event[moments][][date_end]'][value='']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 2

    step 'THEN event is update'
    updated_event = EventRepository.new.last
    expect(updated_event.name).to eq event.name
    expect(updated_event.type).to eq :event

    step 'AND event#earliest_date id updated'
    expect(updated_event.earliest_date).to eq Date.new(1000, 1, 1)

    step 'AND the new moment is created'
    created_moment = MomentRepository.new.last
    expect(created_moment.date_begin).to eq Date.new(1000, 1, 1)
    expect(created_moment.date_end).to eq Date.new(1100, 1, 1)
    expect(created_moment.event_id).to eq updated_event.id
    expect(created_moment.person_id).to be_nil
  end

  scenario 'Admin user open an event page with existent moments' do
    step 'GIVEN an existent event with two moments'
    event = create_second_ww
    create :moment, event_id: event.id, date_begin: Date.new(1000, 1, 1), date_end: Date.new(1100, 1, 1)
    create :moment, event_id: event.id, date_begin: Date.new(1101, 1, 1), date_end: Date.new(1200, 1, 1)

    step 'WHEN I visit the event page'
    visit Admin.routes.edit_event_path(event.id)

    step 'THEN I see two moments for editing'
    # First moment
    expect(page).to have_selector("input[name='event[moments][][date_begin]'][value='1000-01-01']")
    expect(page).to have_selector("input[name='event[moments][][date_end]'][value='1100-01-01']")
    # Second moment
    expect(page).to have_selector("input[name='event[moments][][date_begin]'][value='1101-01-01']")
    expect(page).to have_selector("input[name='event[moments][][date_end]'][value='1200-01-01']")
  end
end
