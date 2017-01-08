require_relative './interactor'

class VerifyAuthCredentials
  extend Interactor

  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    found_user = repository.find_by_email(email)
    !found_user.nil? && right_password(found_user)
  end

  private

  def right_password(user)
    BCrypt::Password.new(user.password) == password
  end

  def repository
    UserRepository.new
  end
end
