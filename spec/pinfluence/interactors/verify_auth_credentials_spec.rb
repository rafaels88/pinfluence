require 'spec_helper'

describe VerifyAuthCredentials do
  describe '#call' do
    let(:email) { 'admin@domain.com' }
    let(:password) { '123!@#qwe()_' }
    let(:credentials) { { email: email, password: password } }

    subject { described_class.new(credentials) }
    before { subject.call }

    context 'when credentials are correct' do
      before do
        create :user, email: email,
                      password: BCrypt::Password.create(password)
      end
      after { database_clean }

      it 'returns true' do
        expect(subject.call).to eq true
      end
    end

    context 'when credentials are incorrect' do
      before do
        create :user, email: email,
                      password: BCrypt::Password.create('wrong')
      end
      after { database_clean }

      it 'returns false' do
        expect(subject.call).to eq false
      end
    end
  end
end
