require 'spec_helper'

describe Users::FindUserByAuthCredentials do
  let(:email) { 'admin@domain.com' }
  let(:password) { '123!@#qwe()_' }
  let(:credentials) { { email: email, password: password } }
  let!(:user) do
    create :user, email: 'admin@domain.com',
                  password: '123!@#qwe()_'
  end

  after { database_clean }

  subject { described_class.new(credentials) }

  describe '#call' do
    before { subject.call }

    context 'when credentials are correct' do
      it 'returns found user' do
        expect(subject.call).to_not be_nil
        expect(subject.call.id).to eq user.id
      end
    end

    context 'when password is incorrect' do
      let(:password) { 'wrong' }
      subject { described_class.new(credentials) }

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end

    context 'when email is incorrect' do
      let(:email) { 'wrong' }
      subject { described_class.new(credentials) }

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end
  end
end
