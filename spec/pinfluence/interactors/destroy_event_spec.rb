require 'spec_helper'

describe DestroyEvent do
  after { database_clean }

  describe '#call' do
    let(:event) { create :event }
    let!(:moment) { create :moment, event_id: event.id }
    let(:event_repository) { EventRepository.new }
    let(:moment_repository) { MomentRepository.new }

    subject { described_class.new(event.id) }
    before { subject.call }

    it 'destroys the event' do
      found_event = event_repository.find(event.id)
      expect(found_event).to be_nil
    end

    it 'destroys related moments' do
      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end
  end
end
