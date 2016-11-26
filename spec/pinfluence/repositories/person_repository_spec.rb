require 'spec_helper'

describe PersonRepository do
  describe "#search_by_name" do
    subject { PersonRepository.new }
    after { database_clean }
    let(:socrates) { build :person, name: "Socrates" }
    let(:plato) { build :person, name: "Plato" }

    before do
      subject.create socrates
      subject.create plato
    end

    it "returns found influencer searched by the exacly given name" do
      result = subject.search_by_name(socrates.name)
      assert_equal 1, result.count
      assert_equal socrates.name, result.first.name
    end

    it "results an empty list for no people found" do
      assert_empty subject.search_by_name("non existent")
    end
  end
end
