class Default
  class << self
    def can_display?(message)
      true 
    end

    def display(message, data)
      message['body']['plain']
    end

    def data(message)
      nil
    end

    def priority
      :normal
    end

    def expire?(message)
      true
    end

    def template
      self.name.downcase
    end

  end
end
