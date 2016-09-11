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

    #starts task time tracking
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

    #stops task time tracking
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

    #creates new todo list file
    def new(file_name)
      @todo_list.create(file_name)
      @undo = lambda { @todo_list.delete(file_name) }
    end

    #deletes new todo list file
    def delete(file_name)
      @todo_list.delete(file_name)
      @undo = lambda { @todo_list.new_todo(file_name) }
    end

    #adds new task
    def add(description, assignee)
      t = Task.new
      t.description = description
      t.assignee = assignee
      @todo_list.add_task(t)
      @undo = lambda do
        @todo_list.remove_task(-1)
      end
    end

    #removes task
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

    #assigns person to task
    def assign(index, person)
      index = index.to_i
      assignee = @todo_list.tasks[index-1].assignee
      @todo_list.tasks[index-1].assign(person)
      @undo = lambda do
        @todo_list.tasks[index-1].assign(assignee)
      end
    end

    #changes tasks status
    def status(index, status)
      index = index.to_i
      prev_status = @todo_list.tasks[index-1].status
      @todo_list.tasks[index.to_i-1].change_status(status)
      @undo = lambda do
        @todo_list.tasks[index-1].change_status(prev_status)
      end
    end

    #prints instruction
    def instruction
      @todo_list.instruction
    end

    #change task position to one step up
    def up(index)
      @todo_list.up(index.to_i-1)
      @undo = lambda { down(index.to_i-1) }
    end

    #change task position to one step down
    def down(index)
      @todo_list.down(index.to_i-1)
      @undo = lambda { up(index.to_i+1) }
    end

    #saves todo list
    def save
      @todo_list.write_todo
    end

    #exit
    def exit
      Kernel.exit
    end
    alias :quit :exit
end
