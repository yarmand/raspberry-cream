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
      mugshot=msg_sender['mugshot_url'].gsub('48x48', '700x700')
      puts ":::::::::::::"
      #pp all_data
      pp mugshot
      puts ":::::::::::::"


      {:mugshot_url => mugshot}
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
