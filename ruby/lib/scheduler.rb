require 'screen'

class Scheduler

  EMPTY_LIST_DELAY = 10

  attr_accessor :browser_adapter, :screen_list

/*
 * config: is a hach containing 
 *         - messages_list_size = 10
 *         - message_display_delai = {normal: 20, priority: 40}
 */
  def initialize(config)
    self.screen_list = ScreenList.new(config[messages_list_size])
  end

  def add_screen(screen)
    screen_list.add(screen)
  end

  def start
    Thread.new do
      loop do
        next_screen
        unless current.nil?
          screen = current.screen
          browser_adapter.display screen.display_path
          sleep @config[:message_display_delai][screen.priority]
        else
          sleep EMPTY_LIST_DELAY
        end
      end
    end
  end

end
