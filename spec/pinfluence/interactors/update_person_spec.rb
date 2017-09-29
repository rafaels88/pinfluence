require 'spec_helper'

describe UpdatePerson do
  after { database_clean }

  describe '#call' do
    let(:person) { create :person, name: 'Albert Einstein', gender: :male }

    let(:new_name) { 'Irmã Dulce' }
    let(:new_gender) { 'female' }
    let(:new_earliest_year) { 1900 }
    let(:update_params) { { name: new_name, gender: new_gender, earliest_year: new_earliest_year } }
    let(:person_params) { update_params.merge(id: person.id) }
    let(:moments_params) { [] }

    let(:person_repository) { PersonRepository.new }
    let(:indexer_instance) { double :InfluencerIndexerInstance, save: true }
    let(:indexer) { double :InfluencerIndexer, new: indexer_instance }

    subject do
      described_class.new(person: person_params, moments: moments_params, opts: { indexer: indexer })
    end

    it 'updates given person' do
      subject.call

      found_person = person_repository.last
      expect(found_person.name).to eq new_name
      expect(found_person.gender).to eq new_gender
      expect(found_person.earliest_year).to eq new_earliest_year
      expect(found_person.updated_at).to_not be_nil
      expect(found_person.created_at).to_not be_nil
    end

    it 'reindexes the created person' do
      expect(indexer_instance).to receive(:save)
      subject.call
    end

    context 'when only one person attribute is given' do
      let(:update_params) { { earliest_year: new_earliest_year } }

      it 'updates only the given attribute' do
        subject.call

        found_person = person_repository.last
        expect(found_person.name).to eq person.name
        expect(found_person.gender).to eq person.gender
        expect(found_person.earliest_year).to eq new_earliest_year
        expect(found_person.updated_at).to_not be_nil
        expect(found_person.created_at).to_not be_nil
      end
    end

    context 'when a list of moments is given' do
      before { subject.call }

      context 'with an empty id' do
        let(:moments_params) { [{ id: '', year_begin: '200', year_end: '300' }] }

        it 'add the new moments' do
          created_moment = MomentRepository.new.search_by_influencer(person).first

          expect(created_moment.person_id).to eq person.id
          expect(created_moment.year_begin).to eq 200
          expect(created_moment.year_end).to eq 300
        end
      end

      context 'with an empty year_begin' do
        let(:moments_params) { [{ id: '', year_begin: '', year_end: '' }] }

        it 'does not create any moment' do
          found_moments = MomentRepository.new.search_by_influencer(person)

          expect(found_moments.count).to eq 0
        end
      end

      context 'with a filled id' do
        let(:existent_moment) { create(:moment, person_id: person.id, year_begin: 200, year_end: 300) }
        let(:moments_params) { [{ id: existent_moment.id, year_begin: '1000', year_end: '' }] }

        it 'updates the existent moment' do
          found_moments = MomentRepository.new.search_by_influencer(person)
          updated_moment = found_moments.first

          expect(found_moments.count).to eq 1
          expect(updated_moment.person_id).to eq person.id
          expect(updated_moment.year_begin).to eq 1000
          expect(updated_moment.year_end).to eq nil
        end
      end
    end
  end
end
