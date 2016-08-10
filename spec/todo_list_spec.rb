require_relative "../todo_list"
require_relative "../task"

RSpec.describe TodoList do
  before(:each) do
    @tasks = File.readlines("./spec/test_tasks.txt")
    @todo_list = TodoList.new
    @task = Task.new("- change tasks undefined")
  end

  it "reads txt file and creates tasks" do
    @todo_list.read_todo("./spec/test_tasks.txt")
    expect(@todo_list.tasks[0].description).to eq("create tasks.txt")
    expect(@todo_list.tasks[1].description).to eq("create rspec tests")
    expect(@todo_list.tasks[2].description).to eq("create read_todo method")
  end

  it "writes txt file with tasks" do
    @todo_list.read_todo("./spec/test_tasks.txt")
    @todo_list.add_task(@task)
    @todo_list.write_todo("./spec/test_tasks2.txt")
    x = File.readlines("./spec/test_tasks2.txt")
    expect(x).to include("- change tasks undefined\n")
    File.delete("./spec/test_tasks2.txt")
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
    task2 = Task.new("- change tasks undefined")
    @todo_list.add_task(@task)
    @todo_list.add_task(task2)
    @todo_list.remove_task(0)
    expect(@todo_list.tasks).to include(task2)
    expect(@todo_list.tasks).not_to include(@task)
  end

end
