require_relative "../command"
require_relative "../task"
require_relative "../todo_list"

RSpec.describe Command do
  before(:each) do
    @todo_list = TodoList.new("./spec/test_tasks.txt")
    @add_task = Command.new(@todo_list, "add, create_some, Roman")
    @add_task.execute
  end

  it "adds tasks to todo list" do
    expect(@todo_list.tasks.last.description).to eq("create_some")
    expect(@todo_list.tasks.last.assignee).to eq("Roman")
  end

  it "removes tasks from todo list" do
    remove_command = Command.new(@todo_list, "remove, 1")
    remove_command.execute
    expect(@todo_list.tasks.length).to eq(0)
  end

  it "assingns User to task" do
    assign_command = Command.new(@todo_list, "assign, 1, Michael")
    assign_command.execute
    expect(@todo_list.tasks[0].assignee).to eq("Michael")
  end

  it "changes task status if status is valid" do
    status_command = Command.new(@todo_list, "status, 1, completed")
    status_command.execute
    expect(@todo_list.tasks[0].status).to eq(:completed)
  end


  it "moves task up" do
    add_task = Command.new(@todo_list, "add, create_some test, Marsel")
    up_task = Command.new(@todo_list, "up, 2")
    add_task.execute
    up_task.execute
    expect(@todo_list.tasks[0].assignee).to eq('Marsel')
    expect(@todo_list.tasks[1].assignee).to eq('Roman')
  end

  it "moves task down" do
    add_another_task = Command.new(@todo_list, "add, create_some test, Marsel")
    down_task = Command.new(@todo_list, "down, 1")
    add_another_task.execute
    down_task.execute
    expect(@todo_list.tasks[1].assignee).to eq('Roman')
    expect(@todo_list.tasks[0].assignee).to eq('Marsel')
  end

  it "starts task time tracking" do
    start = Command.new(@todo_list, "start, 1")
    start.execute
    expect(@todo_list.tasks[0].total_time).to eq(nil)
    expect(@todo_list.tasks[0].start_time).not_to eq(nil)
  end

  it "stops task time tracking" do
    start = Command.new(@todo_list, "start, 1")
    start.execute
    stop = Command.new(@todo_list, "stop, 1")
    stop.execute
    expect(@todo_list.tasks[0].total_time).not_to eq(nil)
    expect(@todo_list.tasks[0].start_time).to eq(nil)
  end


  describe "***undo method***" do
    it "undos add command" do
      @add_task.undo
      expect(@todo_list.tasks.length).to eq(0)
    end

    it "undos command remove" do
      add_task = Command.new(@todo_list, "add, create_some, Marsel")
      add_task.execute
      remove_command = Command.new(@todo_list, "remove, 2")
      remove_command.execute
      remove_command.undo
      expect(@todo_list.tasks.length).to eq(2)
    end

    it "undos command assign" do
      assign_command = Command.new(@todo_list, "assign, 1, Michael")
      assign_command.execute
      assign_command.undo
      expect(@todo_list.tasks[0].assignee).to eq("Roman")
    end

    it "undos command status" do
      status_command = Command.new(@todo_list, "status, 1, completed")
      status_command.execute
      status_command.undo
      expect(@todo_list.tasks[0].status).to eq(:new)
    end

    it "undos command up" do
      add_task = Command.new(@todo_list, "add, create_some test, Marsel")
      up_task = Command.new(@todo_list, "up, 2")
      add_task.execute
      up_task.execute
      up_task.undo
      expect(@todo_list.tasks[0].assignee).to eq('Roman')
      expect(@todo_list.tasks[1].assignee).to eq('Marsel')
    end

    it "undos command down" do
      add_another_task = Command.new(@todo_list, "add, create_some test, Marsel")
      down_task = Command.new(@todo_list, "down, 1")
      add_another_task.execute
      down_task.execute
      down_task.undo
      expect(@todo_list.tasks[0].assignee).to eq('Roman')
      expect(@todo_list.tasks[1].assignee).to eq('Marsel')
    end
  end

end
