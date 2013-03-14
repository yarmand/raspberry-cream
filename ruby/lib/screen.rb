
class Screen
  attr_accessor :id,:message, :screen_module, :module_data, :priority

  PRIORITIES = { normal: 0, high: 10}

  def self.find_by_id(id)
    screens[id]
  end

  def self.screens
    @@screens ||= {}
  end

  def self.delete(id)
    screens.delete id
  end

  def initialize(msg, modules)
    self.id = (0...20).map{ ('a'..'z').to_a[rand(26)] }.join
    self.message = msg
    self.screen_module = modules.select { |m| m.can_display?(msg) }.first
    self.module_data = screen_module.data(message)
    self.priority = screen_module.priority
    self.class.screens[self.id] = self
  end

  def keep_it?
    return false unless PRIORITIES[priority] <= PRIORITIES[:normal]
    ! screen_module.expire?(message: message, data: module_data)
  end

  def display_path
    "/display/#{screen_module.template}/#{id}"
  end

  def delete
    self.class.delete id
  end

  def display
    screen_module.display(message, module_data)
  end
end


