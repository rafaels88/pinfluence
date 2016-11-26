require 'spec_helper'

describe UserRepository do
  subject { UserRepository.new }

  after { database_clean }

  describe "#find_by_email" do
    let(:existent_user) { create :user }

    it "returns found user by given email" do
      found_user = subject.find_by_email(existent_user.email)
      assert_equal existent_user.id, found_user.id
    end

    it "returns nil for non existent given email" do
      assert_nil subject.find_by_email("non-existent")
    end
  end
end
