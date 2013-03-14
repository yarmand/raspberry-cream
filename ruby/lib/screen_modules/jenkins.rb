require 'default'

class Jenkins < Default
  class << self
    def can_display?(message)
      return true if message['body']['plain'] =~ /jenkins.int.yammer.com/ 
      false
    end

    def display(message, data)
      message['body']['plain']
    end

    def data(message)
      r=%r{http://jenkins.int.yammer.com/([^ ]*)}
      p=r.match(message['body']['plain'])[1]
      json=get "http://jenkins.int.yammer.com/#{p}/api/json"
      result = json['result']
      details = json['actions'][6]
      id = json['number']
      {:result => result, :details => details, :id => id}
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
