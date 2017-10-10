require 'spec_helper'

describe DestroyMoment do
  after { database_clean }

  describe '#call' do
    let(:moment) { create :moment }
    let(:moment_repository) { MomentRepository.new }
    let(:indexer_instance) { double :InfluencerIndexerInstance, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }
    let(:opts) { { indexer: indexer } }

    subject { described_class.new(moment.id, opts: opts) }

    it 'destroys given moment' do
      subject.call

      found_moment = moment_repository.find(moment.id)
      expect(found_moment).to be_nil
    end

    context 'when an influencer has the moment associated to it' do
      let(:influencer) { create :person, earliest_date: Date.new(1000, 1, 1) }
      let(:moment) { create :moment, date_begin: Date.new(1000, 1, 1), person_id: influencer.id }

      before { create :moment, date_begin: Date.new(1200, 1, 1), person_id: influencer.id }

      it 'updates earliest_date for the associated influencer' do
        subject.call

        reloaded_influencer = PersonRepository.new.find(influencer.id)
        expect(reloaded_influencer.earliest_date).to eq Date.new(1200, 1, 1)
      end
    end
  end
end
