module Influencer
  def type
    self.class.to_s.downcase.to_sym
  end
end
