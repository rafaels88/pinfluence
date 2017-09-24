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

    step 'AND I set a Year Begin for a new moment'
    set_input_value '1000', from: "input[name='event[moments][][year_begin]'][value='']"

    step 'AND I set a Year End for a new moment'
    set_input_value '1100', from: "input[name='event[moments][][year_end]'][value='']"

    step 'WHEN I click on Update button'
    click_on 'Update'
    sleep 2

    step 'THEN event is update'
    updated_event = EventRepository.new.last
    expect(updated_event.name).to eq event.name
    expect(updated_event.type).to eq :event

    step 'AND event#earliest_year id updated'
    expect(updated_event.earliest_year).to eq 1000

    step 'AND the new moment is created'
    created_moment = MomentRepository.new.last
    expect(created_moment.year_begin).to eq 1000
    expect(created_moment.year_end).to eq 1100
    expect(created_moment.event_id).to eq updated_event.id
    expect(created_moment.person_id).to be_nil
  end

  scenario 'Admin user open an event page with existent moments' do
    step 'GIVEN an existent event with two moments'
    event = create_second_ww
    create :moment, event_id: event.id, year_begin: 1000, year_end: 1100
    create :moment, event_id: event.id, year_begin: 1101, year_end: 1200

    step 'WHEN I visit the event page'
    visit Admin.routes.edit_event_path(event.id)

    step 'THEN I see two moments for editing'
    # First moment
    expect(page).to have_selector("input[name='event[moments][][year_begin]'][value='1000']")
    expect(page).to have_selector("input[name='event[moments][][year_end]'][value='1100']")
    # Second moment
    expect(page).to have_selector("input[name='event[moments][][year_begin]'][value='1101']")
    expect(page).to have_selector("input[name='event[moments][][year_end]'][value='1200']")
  end
end
