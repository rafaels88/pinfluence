require_relative './interactor'

class FindUserByAuthCredentials
  include Interactor

  attr_reader :email, :password
  expose :user

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    if found? && right_password?
      @user = found_user
    else
      add_error('User and/or email not found')
    end
  end

  private

  def found_user
    @_found_user ||= repository.find_by_email(email)
  end

  def found?
    !found_user.nil?
  end

  def right_password?
    BCrypt::Password.new(found_user.password) == password
  end

  def repository
    UserRepository.new
  end
end
