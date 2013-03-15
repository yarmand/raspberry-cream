require 'pp'
require 'scheduler'

class YammerPoller
  POLL_INTERVAL = 20 # seconds
  MODULES_DIR = 'lib/screen_modules'

  def initialize(scheduler)
    @scheduler = scheduler

    # Load the list of modules
    @modules = load_modules_from_disk
    puts "Loaded modules #{@modules.inspect}"

    if File.exists?('token')
      @auth_token = File.read('token')

      # Protect aginst empty file / nonsense contents
      @auth_token = nil if @auth_token.length < 10
      puts "Poller using auth token '#{@auth_token}'"
    end
  end

  def authorised?
    !!@auth_token
  end

  def load_modules_from_disk
    modules = Dir.glob(MODULES_DIR + "/*.rb").map do |file|
      puts file
      
      puts File.basename(file, '.rb')
      require "screen_modules/#{File.basename(file, '.rb')}"
      Module.const_get(File.basename(file, '.rb').split('_').map(&:capitalize).join)
    end

    # Move the default module to the end of the list.
    default_module = modules.delete(Default)
    raise "No 'Default' module" unless default_module
    modules << default_module
  end

  def poll
    raise "Not Authorised" unless authorised?
    loop do 
      limit = @last_msg_id ? "newer_than=#@last_msg_id" : "limit=2"
      response = HTTParty.get("https://www.yammer.com/api/v1/messages/following.json?access_token=#{@auth_token}&threaded=extended&#{limit}")

      if response.code == 200
        json = response.parsed_response
        messages = json['messages']
        threaded = json['threaded_extended']
        puts "Threaded messages #{threaded.keys.inspect}"
        messages.each do |msg|
          puts "#{msg['id'].inspect} => #{msg['body']['plain']}"
          responses = threaded[msg['id'].to_s]

          if responses
            responses.map do |response|
              puts "  #{response['id']} => #{response['body']['plain']}"
              response
            end
            responses.reverse # Put newest last in the array
          end

          screen = Screen.new({msg: msg, responses: (responses || [])}, @modules)
          @scheduler.add_screen(screen)
        end

        #pp json

        # Remember where we got to, so that we can fetch only new messages.
        if messages.first
          @last_msg_id = messages.first['id']
          puts "Last msg: #{@last_msg_id}"
        else
          puts "No new messages"
        end
      else
        raise "Unexpected response code #{response.code}"
      end

      sleep(POLL_INTERVAL)
    end
  end
end
