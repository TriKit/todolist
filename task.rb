class Task
  attr_accessor :status, :assignee, :description

  def initialize(task_line=nil)
    self.status ||= :new
    if task_line
      task_array = task_line.split(' ')
      self.status = parse_status(task_array.shift)
      (x = task_array.pop) == "undefined" ? self.assignee = nil : self.assignee = x
      self.description = task_array.join(' ')
    end
  end

  def parse_status(s=self.status, colorize: false)
    colors = { completed: :green, new: :red, in_progress: :orange, pause: :white }
    statuses = { completed: "+", new: "-", in_progress: "*", pause: "zzz" }
    result = if s.kind_of?(String)
      statuses.invert[s]
    else
      statuses[s]
    end
    colorize ? result.color(colors[s]) : result
  end

  def change_assignee(description, person)
    self.assignee = person if self.description == description
  end

  def line_for_file
    a = assignee == nil ? "undefined" : assignee
    "#{parse_status} #{description} #{a}"
  end

  def line_for_display(number)
    a = assignee == nil ? "undefined" : assignee
    "#{parse_status} #{number}. task: #{description} assignee: #{a}"
  end

end
