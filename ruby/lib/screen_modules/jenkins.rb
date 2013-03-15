require 'screen_modules/default'

class Jenkins < Default
  class << self
    def can_display?(message)
      return true if plain(message) =~ /jenkins.int.yammer.com/ 
      false
    end

    def display(message, data)
      plain(message)
    end

    def data(message)
      r=%r{jenkins.int.yammer.com/([^ ]*)}
      p=r.match(plain(message))[1]
      json=get "http://jenkins.int.yammer.com/#{p}/api/json"
      result = json['result']
      details = json['actions'][6]
      id = json['fullDisplayName']
      {:result => result, :details => details, :id => id}
    end

    def plain(message)
      if message[:responses].empty?
        m=message[:msg]
      else
        m=message[:responses].last
      end
      m['body']['plain']
    end

    def expire?
      false
    end
  end
end
