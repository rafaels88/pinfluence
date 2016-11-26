require 'spec_helper'

describe PersonRepository do
  subject { PersonRepository.new }
  after { database_clean }
  let(:alexander) { build :person, name: "Alexander" }
  let(:cleopatra) { build :person, name: "Cleopatra" }
  let(:socrates) { build :person, name: "Socrates" }
  let(:plato) { build :person, name: "Plato" }

  before do
    subject.create socrates
    subject.create plato
    subject.create alexander
    subject.create cleopatra
  end

  describe "#search_by_name" do
    it "returns found influencer searched by the exacly given name" do
      result = subject.search_by_name(socrates.name)
      assert_equal 1, result.count
      assert_equal socrates.name, result.first.name
    end

    it "results an empty list for no people found" do
      assert_empty subject.search_by_name("non existent")
    end
  end

  describe "#all_ordered_by" do
    it "returns all people ordered by given name" do
      expected_names = [alexander.name, cleopatra.name,
        plato.name, socrates.name]

      assert_equal expected_names, subject.all_ordered_by(:name).map(&:name)
    end
  end
end
