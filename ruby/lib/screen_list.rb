
class ScreenList
  Cell = Struct.new(:screen, :next)

  attr_accessor :current, :list

  def initialize(max_size)
    self.current = nil
    @current_index=0
    @max_size = max_size
    self.list = []
  end

  def add(screen)
    list << screen
    normalize
  end

  def normalize
    list.each do |screen|
      return if list.size <= @max_size
      unless screen.keep_it?
        list.delete screen
      end
    end
  end

  def next
    @current_index += 1
    @current_index = 0 if @current_index >= list.size
    current
  end

  def current
    list[@current_index]
  end

end

