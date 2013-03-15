require 'screen_modules/default'
require 'pp'

class Shamehat < Default
  class << self
    def can_display?(message)
      return plain(message).include?('#shamehat')
    end

    def display(message, data)
      plain(message)
    end

    def data(message)
      msg = message[:msg]
      responses = message[:responses]
      all_data = message[:all_data]
      msg_sender = all_data['references'].find do |ref|
        ref['id'] == msg['sender_id']
      end

      puts ":::::::::::::"
      #pp all_data
      pp msg_sender['mugshot_url'].gsub('48x48', '800x800')
      puts ":::::::::::::"


      #{:result => result, :details => details, :id => id}
    end

    def plain(message)
      if message[:responses].empty?
        m=message[:msg]
      else
        m=message[:responses].last
      end
      m['body']['plain']
    end

    def expire?(message)
      false
    end
  end
end
