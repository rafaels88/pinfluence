require_relative './interactor'

class CreateUser
  include Interactor

  attr_reader :name, :email, :repository

  def initialize(name:, email:, password:, repository: UserRepository.new)
    @name = name.strip
    @email = email.strip
    @password = password.strip
    @repository = repository
  end

  def call
    repository.create(new_user)
  end

  private

  def new_user
    User.new(name: name, email: email, password: password)
  end

  def password
    BCrypt::Password.create(@password)
  end
end
