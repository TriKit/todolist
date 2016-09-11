require 'rainbow/ext/string'

class Task
  attr_accessor :status, :assignee, :description, :start_time, :total_time

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
    result = s.kind_of?(String) ? statuses.invert[s] : statuses[s]
    colorize ? result.color(colors[s]) : result
  end

  def change_status(status)
    status = status.to_s.rstrip.to_sym
    return false unless [:completed, :new, :in_progress, :pause].include?(status)
    @status = status
  end

  def assign(person)
    @assignee = person
  end

  def line_for_file
    s = start_time == nil ? "?" : start_time
    t = total_time == nil ? "?" : total_time
    a = assignee == nil ? "undefined" : assignee
    "#{parse_status} #{description} #{a}"
  end

  def line_for_display(number)
    s = start_time == nil ? "?" : start_time
    t = total_time == nil ? "?" : total_time
    a = assignee == nil ? "undefined" : assignee
    "#{parse_status(colorize: true)} #{number}. task: #{description} assignee: #{a.capitalize} start time: #{s} total time: #{t}"
  end

  def start
    # if @start_time == nil
    #   @start_time = Time.now.to_i
    # end
    @start_time ||= Time.now.to_i
  end

  def stop
    if @start_time
      @total_time = Time.now.to_i - @start_time
      @start_time = nil
    end
  end

end
