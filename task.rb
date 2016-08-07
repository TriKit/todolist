class Task
  attr_accessor :status, :assignee, :description

  def initialize(task_line=nil)
    if task_line
      task_array = task_line.split(' ')
      self.status = parse_status(task_array.shift)
      (x = task_array.pop) == "undefined" ? self.assignee = nil : self.assignee = x
      # if task_array.last == "undefined" # переделать с тернарным оператором
      #   self.assignee = nil
      #   task_array.pop
      # else
      #   self.assignee = task_array.pop
      # end
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

  def change_status(description, status)
    status = status.to_sym
    return false unless [:completed, :new, :in_progress, :pause].include?(status)
    self.status = status
  end

  def change_assignee(description, person)
    self.assignee = person if self.description == description
  end

  def line_for_file
    "#{parse_status} #{description} #{assignee}"
  end

  def line_for_display(number)
    "#{parse_status} #{number}. task: #{description} assignee: #{assignee}"
  end

end
