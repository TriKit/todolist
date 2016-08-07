
class TodoList

  attr_reader :tasks
  @tasks = File.readlines("tasks.txt")

  def read_todo
    p @tasks
  end

  def add_task(task)
    @tasks ||= []
    @tasks << task
  end

  def remove_task(index)
    @tasks.delete_at(index)
  end

  def mark_as_completed(task)
    task.status = :completed
  end

end
