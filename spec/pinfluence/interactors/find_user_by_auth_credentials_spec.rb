require 'spec_helper'

describe FindUserByAuthCredentials do
  let(:email) { 'admin@domain.com' }
  let(:password) { '123!@#qwe()_' }
  let(:credentials) { { email: email, password: password } }
  let!(:user) do
    create :user, email: 'admin@domain.com',
                  password: BCrypt::Password.create('123!@#qwe()_')
  end

  after { database_clean }

  subject { described_class.new(credentials) }

  describe '#call' do
    before { subject.call }

    context 'when credentials are correct' do
      it 'returns found user' do
        expect(subject.call.user).to_not be_nil
        expect(subject.call.user.id).to eq user.id
      end
    end

    context 'when password is incorrect' do
      let(:password) { 'wrong' }
      subject { described_class.new(credentials) }

      it 'returns error' do
        expect(subject.call.errors).to_not be_empty
      end
    end

    context 'when email is incorrect' do
      let(:email) { 'wrong' }
      subject { described_class.new(credentials) }

      it 'returns error' do
        expect(subject.call.errors).to_not be_empty
      end
    end
  end
end
