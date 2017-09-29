require_relative '../../interactors/interactor'

module Users
  class FindUserByAuthCredentials
    include Interactor

    attr_reader :email, :password

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      found_user if found? && right_password?
    end

    private

    def found_user
      @found_user ||= repository.find_by_email(email)
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
end
