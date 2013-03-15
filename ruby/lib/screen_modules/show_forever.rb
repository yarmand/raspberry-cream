class ShowForever
  class << self
    def can_display?(message)
      puts "ShowForever can display? #{message[:msg]['body']['plain'].inspect}"
      /(Display)|(Show) forever/i.match(message[:msg]['body']['plain'])
    end

    def display(message, data)
      message[:msg]['body']['plain']
    end

    def data(message)
      nil
    end

    def priority
      :normal
    end

    # Show forever messages never expire
    def expire?(message)
      false
    end
    
    def url(message)
      if /(http:\/\/\S*)/.match(message[:msg]['body']['plain'])
        puts "Got URL #{$1}"
        $1
      else
        # Couldn't find a URL to display
        nil
      end
    end

    def template
      self.name.downcase
    end

  end
end

