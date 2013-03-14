require 'test/unit/test_helper'

require 'screen_list'

class SchedulerTest < Test::Unit::TestCase

  class FakeScreen
    attr_accessor :name
    def keep_it?
      false
    end
  end

  def setup
    @l=ScreenList.new(3)
  end

  def test_add_1
    v='lapin'
    @l.add(v)
    assert_equal @l.next, v
  end

  def test_add_4
    (1..5).each do |i| 
      puts i
      s = FakeScreen.new
      s.name = "screen_#{i}"
      @l.add(s)
    end
    assert_equal 3, @l.send(:list).size
  end

end
