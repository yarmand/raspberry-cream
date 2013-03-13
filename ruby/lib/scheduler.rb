
class Scheduler
  Cell = Struct.new(:message, :next)

  def initialize
    @current = nil
    @first = nil 
  end

  def add_message(msg)
    if @first.nil?
      @first = Cell(msg,nil)
      @curent = @first
    else
      @first = Cell.new(msg, @first)
    end
  end

  def garbage_collect
  end

  def next_message
    curent = curent.next
    current.message
  end

  def current
    if @current.nil?
      return Cell.new(nil,@first)
    end
    @current
  end
end
