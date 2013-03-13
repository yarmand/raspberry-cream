
class Scheduler
  Cell = Struct.new(:screen, :next)

  EMPTY_LIST_DELAY = 10

  attr_accessor :browser_adapter

  /**
    * config: is a hach containing ...
    *         - messages_list_size = 10
    *         - message_display_delai = {normal: 20, priority: 40}
    */
  def initialize(config)
    @current = nil
    @first = nil 
    @size = 0
    @config = config
    @max_size = config[:messages_list_size]
  end

  def add_screen(screen)
    if @first.nil?
      @first = Cell(screen,nil)
      @curent = @first
    else
      @first = Cell.new(screen, @first)
    end
    @size += 1
  end

  def normalize(list)
    return nil if list.nil?
    cell = list
    until cell.nil? || @size <= @max_size do
      return cell if cell.screen.keep_it?
      cell = cell.next
    end
    cell.next = normalize cell.next unless cell.nil?
    cell
  end

  def next_screen
    curent = curent.next
    Thread.new {@first = normalize(@first)} if current.nil?
    current.screen
  end

  def current
    if @current.nil?
      return Cell.new(nil,@first)
    end
    @current
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
