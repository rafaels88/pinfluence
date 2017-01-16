require_relative '../../../lib/ext/interactors/interactor'
require_relative '../../support/interactor'

RSpec.describe Interactors::Interactor do
  describe '.call' do
    let(:params) { { param1: 'value', params2: 'value2' } }
    let(:expected) { double }

    before do
      allow(subject).to receive(:call).with(params).and_return expected
    end

    it 'calls #call for a new instance of the interactor with given params' do
      expect(described_class.call(params)).to eq expected
    end
  end

  describe '#call' do
    context 'with no raises' do
      let(:result) { double 'Result' }

      subject { NoopInteractor.new }

      before do
        allow(Interactors::Result).to receive(:new).and_return result
      end

      it 'returns a Result object' do
        expect(subject.call).to eq result
      end
    end

    context 'when #fail! is called' do
      subject { FailerInteractor.new }

      it 'returns a Result#failure? == true' do
        result = subject.call
        expect(result.failure?).to eq true
      end

      it 'returns a Result#success? == false' do
        result = subject.call
        expect(result.success?).to eq false
      end
    end

    context 'when #add_error is called with and error' do
      subject { ErroredInteractor.new }

      it 'returns a Result#failure? == true' do
        result = subject.call
        expect(result.failure?).to eq true
      end

      it 'returns a Result#success? == false' do
        result = subject.call
        expect(result.success?).to eq false
      end

      it 'returns all added error in result object' do
        result = subject.call
        result.errors.each do |error|
          expect(error).to_not be_nil
        end
      end
    end

    context 'when no error occurred' do
      subject { SuccessInteractor.new }

      it 'returns a Result#failure? == false' do
        result = subject.call
        expect(result.failure?).to eq false
      end

      it 'returns a Result#success? == true' do
        result = subject.call
        expect(result.success?).to eq true
      end
    end

    context 'when an attribute is exposed' do
      let(:exposed_value) { 'EXPOSED' }
      subject { ExposerInteractor.new(exposed_value) }

      it 'returns a Result#failure? == false' do
        result = subject.call
        expect(result.failure?).to eq false
      end

      it 'returns a Result#success? == true' do
        result = subject.call
        expect(result.success?).to eq true
      end

      it 'returns the exposed attribute as an attribute in Result object' do
        expect(subject.call.exposed).to eq exposed_value
      end

      it 'raises NoMethodError for non exposed attribute' do
        expect { subject.call.non_exposed }.to raise_error NoMethodError
      end
    end
  end
end
