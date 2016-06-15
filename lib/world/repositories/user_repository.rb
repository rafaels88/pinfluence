class UserRepository
  include Hanami::Repository

  def find_by_email(email:)
    query do
      where(email: email)
    end.first
  end
end
