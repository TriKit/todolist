require 'rainbow/ext/string'
require './time_format'

class Task
  include TimeFormat

  attr_accessor :status, :assignee, :description, :start_time, :total_time

  def initialize(task_line=nil)
    #"status,description,assignee,start,total"
    self.status ||= :new
    if task_line
      task_array = task_line.split(',')
      self.status = parse_status(task_array[0])
      self.description = task_array[1]
      (x = task_array[2]) == "undefined" ? self.assignee = nil : self.assignee = x
      (s = task_array[3]) == "?" ? self.start_time = nil : self.start_time = s.to_i
      (t = task_array[4]) == "?" ? self.total_time = nil : self.total_time = t.to_i
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
    "#{parse_status},#{description},#{a},#{s},#{t}"
  end

  def line_for_display(number)
    s = start_time == nil ? "?" : Time.at(start_time).strftime("%H:%M:%S")
    t = total_time == nil ? "?" : seconds_to_units(total_time)
    a = assignee == nil ? "undefined" : assignee
    "#{parse_status(colorize: true)} #{number}. task: #{description} assignee: #{a.capitalize} #{s} #{t}"
  end

  def start
    # if @start_time == nil
    #   @start_time = Time.now.to_i
    # end
    @start_time ||= Time.now.to_i
  end

  #fix tests
  def stop
    if @start_time
      @total_time = Time.now.to_i - @start_time + (@total_time || 0)
      @start_time = nil
    end
    change_status(:completed)
  end

end
