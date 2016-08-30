require_relative "../command"
require_relative "../task"
require_relative "../todo_list"

RSpec.describe Command do
  before(:each) do
    @todo_list = TodoList.new("./spec/test_tasks.txt")
    @c1 = Command.new(@todo_list, "add, create_some, Roman")
    @c1.execute
  end

  it "adds tasks to todo list" do
    expect(@todo_list.tasks.last.description).to eq("create_some")
    expect(@todo_list.tasks.last.assignee).to eq("Roman")
   end

  it "removes tasks from todo list" do
    c2 = Command.new(@todo_list, "remove, 1")
    c2.execute
    expect(@todo_list.tasks.length).to eq(0)
  end

  it "assingns User to task" do
    c2 = Command.new(@todo_list, "assign, 1, Michael")
    c2.execute
    expect(@todo_list.tasks[0].assignee).to eq("Michael")
  end

  it "changes task status if status is valid" do
    c2 = Command.new(@todo_list, "status, 1, completed")
    c2.execute
    expect(@todo_list.tasks[0].status).to eq(:completed)
  end

  it "moves task up" do
    c2 = Command.new(@todo_list, "add, create_some test, Marsel")
    c3 = Command.new(@todo_list, "up, 2")
    c2.execute
    c3.execute
    expect(@todo_list.tasks[0].assignee).to eq('Marsel')
    expect(@todo_list.tasks[1].assignee).to eq('Roman')
  end


  it "moves task down" do
    c2 = Command.new(@todo_list, "add, create_some test, Marsel")
    c3 = Command.new(@todo_list, "down, 1")
    c2.execute
    c3.execute
    expect(@todo_list.tasks[1].assignee).to eq('Roman')
    expect(@todo_list.tasks[0].assignee).to eq('Marsel')
  end

end
