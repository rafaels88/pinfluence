module Influencer
  SEARCH_INDEX_NAME = 'influencers'.freeze
  SEARCHABLE_ATTRIBUTES = ['name'].freeze

  def type
    self.class.to_s.downcase.to_sym
  end
end
