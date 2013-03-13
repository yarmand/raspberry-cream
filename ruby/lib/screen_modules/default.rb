
class ScreenModules::Default
  def can_display?(message)
    true 
  end

  def display(message: nil, data: nil)
    message['body']
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
