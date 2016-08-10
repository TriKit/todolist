class TodoList

  attr_reader :tasks

  def read_todo(file)
    tasks = File.readlines(file)
    tasks.each do |task_line|
      add_task(Task.new(task_line))
    end
  end

  def write_todo(file)
    File.open(file, 'w') do |f|
      @tasks.each { |t| f.puts(t.line_for_file) }
    end
  end

  def add_task(task)
    @tasks ||= []
    @tasks << task
  end

  def remove_task(index)
    @tasks.delete_at(index)
  end

  def mark_as_completed(id)
    @tasks[id].status = :completed
  end

  def print
    @tasks.each_with_index { |t, i| puts(t.line_for_display(i)) }
  end

end
