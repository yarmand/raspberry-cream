class Default
  class << self
  def can_display?(message)
    true 
  end

  def display(message: nil, data: nil)
    message['body']['plain']
  end

  def data(message)
    nil
  end

  def priority
    Screen::PRIORITIES[:normal]
  end

  def expire?
    true
  end

end
end
