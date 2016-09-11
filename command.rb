require 'rainbow/ext/string'

class Command

  attr_accessor :todo_list, :name

  def initialize(todo_list, command_string)
    @todo_list = todo_list
    command_arr = command_string.split(',')
    @name = command_arr.shift.rstrip
    @args = command_arr
    @args = command_arr.map do |i|
      i[0] = '' if i[0] == " "
      i
    end
  end

  def execute
    send(@name, *@args)
  end

  def undo
    @undo.call
  end

  private

    def start(index)
      index = index.to_i - 1
      @todo_list.tasks[index].start
      puts "Start time tracking task number #{index+1} at #{Time.now}".color(:green)
      @undo = lambda do
        @todo_list.tasks[index].stop
        @todo_list.tasks[index].start_time = nil
        puts "Time tracking suspended".color(:red)
      end
    end

    def stop(index)
      index = index.to_i - 1
      st = @todo_list.tasks[index].start_time
      @todo_list.tasks[index].stop
      puts "Stop time tracking task number #{index+1} at #{Time.now} | Total time is #{@todo_list.tasks[index].total_time}".color(:orange)
      @undo = lambda do
        @todo_list.tasks[index].start_time = st
        @todo_list.tasks[index].total_time = nil
        puts "Time tracking restored. Start time equal #{@todo_list.tasks[index].start_time}".color(:green)
      end
    end

    def new_todo(file_name)
      @todo_list.create(file_name)
      @undo = lambda { @todo_list.delete(file_name) }
    end

    def delete_todo(file_name)
      @todo_list.delete(file_name)
      @undo = lambda { @todo_list.new_todo(file_name) }
    end

    def add(description, assignee)
      t = Task.new
      t.description = description
      t.assignee = assignee
      @todo_list.add_task(t)
      @undo = lambda do
        @todo_list.remove_task(-1)
      end
    end

    def remove(index)
      if index =~ /\A\d+\Z/
        index = index.to_i - 1
        task = @todo_list.tasks[index]
        tasks = @todo_list.tasks
        @todo_list.remove_task(index)
        @undo = lambda do
          tasks.insert(index, task)
        end
        @todo_list.tasks = tasks
      end
    end

    def assign(index, person)
      index = index.to_i
      assignee = @todo_list.tasks[index-1].assignee
      @todo_list.tasks[index-1].assign(person)
      @undo = lambda do
        @todo_list.tasks[index-1].assign(assignee)
      end
    end

    def status(index, status)
      index = index.to_i
      prev_status = @todo_list.tasks[index-1].status
      @todo_list.tasks[index.to_i-1].change_status(status)
      @undo = lambda do
        @todo_list.tasks[index-1].change_status(prev_status)
      end
    end

    def instruction
      @todo_list.instruction
    end

    def up(index)
      @todo_list.up(index.to_i-1)
      @undo = lambda { down(index.to_i-1) }
    end

    def down(index)
      @todo_list.down(index.to_i-1)
      @undo = lambda { up(index.to_i+1) }
    end

    def save
      @todo_list.write_todo
    end

    def exit
      Kernel.exit
    end
    alias :quit :exit
end
