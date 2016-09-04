require 'rainbow/ext/string'

class TodoList

  attr_reader :tasks, :file_name
  attr_writer :tasks

  def initialize(file_name)
    @file_name = file_name
  end

  def instruction
    puts "----------TO LIST-------------".color(:yellow)
    puts "All command arguments should separate by comma".color(:red)
    puts "Commands: ".color(:yellow)
    puts "add, task, person".color(:blue) + " - adds task to todo list with assignee person".color(:yellow)
    puts "remove, task number".color(:blue) + " - removes task from todo list".color(:yellow)
    puts "status, task number, status".color(:blue) + " - change tasks status".color(:yellow)
    puts "assign, task number, person".color(:blue) + " - add responsible person if he was not previously appointed or reassign for one task".color(:yellow)
    puts "up, task number".color(:blue) + " - moves task up".color(:yellow)
    puts "down, task number".color(:blue) + " - moves task down".color(:yellow)
    puts "save".color(:blue) + " - saves changes in file".color(:yellow)
  end

  def read_todo
    tasks = File.readlines(@file_name)
    tasks.each do |task_line|
      add_task(Task.new(task_line))
    end
  end

  def write_todo
    File.open(@file_name, 'w') do |f|
      @tasks.each { |t| f.puts(t.line_for_file) }
    end
  end

  def add_task(task, person=nil)
    @tasks ||= []
    @tasks << task
  end

  def remove_task(index)
    if get_by_index(index)
      @tasks.delete_at(index)
    end
  end

  def print
    if @tasks.empty?
      instruction
    else
      @tasks.each_with_index { |t, i| puts(t.line_for_display(i+1)) }
    end
  end

  def up(index)
    a = get_by_index(index)
    b = get_by_index(index - 1)
    if a && b
      @tasks[index] = b
      @tasks[index - 1] = a
    end
  end

  def down(index)
    a = get_by_index(index)
    b = get_by_index(index + 1)
    if a && b
      @tasks[index] = b
      @tasks[index + 1] = a
    end
  end

  def get_by_index(index)
    if index > @tasks.length-1
      puts "There is no such task"
      false
    else
      @tasks[index]
    end
  end

end
