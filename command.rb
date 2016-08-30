require 'rainbow/ext/string'

class Command

  attr_accessor :todo_list

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

  private

    def add(description, assignee)
      t = Task.new
      t.description = description
      t.assignee = assignee
      @todo_list.add_task(t)
    end

    def remove(index)
      @todo_list.remove_task(index.to_i - 1)
    end

    def assign(index, person)
      @todo_list.tasks[index.to_i-1].assign(person)
    end

    def status(index, status)
      @todo_list.tasks[index.to_i-1].change_status(status)
    end

    def instruction
      @todo_list.instruction
    end

    def up(index)
      @todo_list.up(index.to_i-1)
    end

    def down(index)
      @todo_list.down(index.to_i-1)
    end

    def save
      @todo_list.write_todo
    end

    def exit
      Kernel.exit
    end
    alias :quit :exit
end
