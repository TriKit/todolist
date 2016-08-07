require_relative "../todo_list"
require_relative "../task"

RSpec.describe TodoList do
  before(:each) do
    @tasks = File.readlines("./spec/test_tasks.txt")
    @todo_list = TodoList.new
    @task = Task.new("- create tasks.txt undefined")
  end

  it "reads txt file and creates tasks" do
    @todo_list.read_todo
    expect(@todo_list.length).to eq(3)
  end

  it "writes txt file with tasks" do

  end

  it "marks tasks as completed" do
    @todo_list.mark_as_completed(@task)
    expect(@task.status).to eq(:completed)
  end

  it "adds tasks" do
    @todo_list.add_task(@task)
    expect(@todo_list.tasks).to include(@task)
  end

  it "removes tasks" do
    task2 = Task.new("- create tasks.txt undefined")
    @todo_list.add_task(@task)
    @todo_list.add_task(task2)
    @todo_list.remove_task(0)
    expect(@todo_list.tasks).to include(task2)
    expect(@todo_list.tasks).not_to include(@task)
  end

end
