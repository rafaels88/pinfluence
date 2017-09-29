module Influencer
  def type
    self.class.to_s.downcase.to_sym
  end

  def person?
    false
  end

  def event?
    false
  end
end
