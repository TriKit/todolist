require 'rainbow/ext/string'

class TodoList

  attr_accessor :tasks
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
    create_file
  end

  def instruction
    puts "----------TO LIST-------------".color(:yellow)
    puts "---All todo files---".color(:orange)
    show_todo_lists
    puts "--------------------".color(:orange)
    puts "All command arguments should be separated by comma".color(:orange)
    puts "Commands: ".color(:yellow)
    puts "new, file_name".color(:blue) + " - creates todo list file".color(:yellow)
    puts "delete, file_name".color(:blue) + " - removes todo list file".color(:yellow)
    puts "add, task, person".color(:blue) + " - adds task to todo list with assignee person".color(:yellow)
    puts "remove, task number".color(:blue) + " - removes task from todo list".color(:yellow)
    puts "status, task number, status".color(:blue) + " - changes tasks status".color(:yellow)
    puts "assign, task number, person".color(:blue) + " - adds assignee person if not assigned or reassign for one task".color(:yellow)
    puts "start, task number".color(:blue) + " - starts time tracking".color(:yellow)
    puts "stop, task number".color(:blue) + " - starts time tracking".color(:yellow)
    puts "save".color(:blue) + " - saves changes in file".color(:yellow)
    puts "up, task number".color(:blue) + " - moves task up".color(:yellow)
    puts "down, task number".color(:blue) + " - moves task down".color(:yellow)
  end

  def show_todo_lists
    entries = Dir.entries('./todo_folder')
    entries.delete(".")
    entries.delete("..")
    entries.each do |f|
      puts f.color(:green)
    end
  end

  def create_file
    unless File.exists?("./todo_folder/#{@file_name}")
      File.new("./todo_folder/#{@file_name}", "w")
    end
  end

  def delete(file_name)
    File.delete("./todo_folder/#{file_name}")
  end

  def read_todo
    tasks = File.readlines("./todo_folder/#{@file_name}")
    tasks.each do |task_line|
      add_task(Task.new(task_line))
    end
  end

  def write_todo
    File.open("./todo_folder/#{@file_name}", 'w') do |f|
      if @tasks
        @tasks.each { |t| f.puts(t.line_for_file) }
      end
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
    if @tasks == nil || @tasks.empty?
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
