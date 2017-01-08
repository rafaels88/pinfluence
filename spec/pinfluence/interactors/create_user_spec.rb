require 'spec_helper'

describe CreateUser do
  after { database_clean }

  describe '#call' do
    let(:name) { 'Rafael Soares  ' }
    let(:email) { 'rafael@domain.com  ' }
    let(:password) { '123QWE()_ASD  ' }
    let(:encrypted_password) { BCrypt::Password.create(password.strip) }
    let(:user_params) { { name: name, email: email, password: password } }
    let(:user_repository) { UserRepository.new }

    subject { described_class.new(user_params) }
    before do
      allow(BCrypt::Password).to receive(:create).and_return encrypted_password
      subject.call
    end

    let(:found_user) { user_repository.last }

    it 'creates new user' do
      expect(found_user.id).to_not be_nil
      expect(found_user.name).to eq name.strip
      expect(found_user.updated_at).to_not be_nil
      expect(found_user.created_at).to_not be_nil
    end

    it 'ensures email value is stripped' do
      expect(found_user.email).to eq email.strip
    end

    it 'creates stripped password using bcrypt() password hashing algorithm' do
      expect(found_user.password).to eq encrypted_password
    end
  end
end
