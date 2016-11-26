require 'spec_helper'

describe MomentRepository do
  subject { MomentRepository.new }

  after { database_clean }

  describe "#all_available_years" do
    let(:first_year) { 100 }
    let(:last_year) { 750 }

    before do
      create :moment, year_begin: first_year, year_end: 150
      create :moment, year_begin: 300, year_end: 320
      create :moment, year_begin: 700, year_end: last_year
    end

    it "returns a list with all years since first moment until last moment" do
      assert_equal (first_year..last_year).to_a, subject.all_available_years
    end

    describe "when there is a moment with no year_end" do
      let(:current_year) { Time.now.year }
      after { database_clean }

      before do
        create :moment, year_begin: 800, year_end: nil
      end

      it "returns a list with all years since first moment until current year" do
        assert_equal (first_year..current_year).to_a, subject.all_available_years
      end
    end

    describe "when there are no moments" do
      before do
        subject.clear
      end

      it "returns an empty list" do
        assert_empty subject.all_available_years
      end
    end
  end
end
