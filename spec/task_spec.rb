require_relative "../task"

RSpec.describe Task do

  it "parses status, description and assignee" do
    task = Task.new("+ create tasks.txt Marsel")
    task2 = Task.new("+ create tasks.txt undefined")
    expect(task.status).to eq(:completed)
    expect(task.description).to eq("create tasks.txt")
    expect(task.assignee).to eq("Marsel")
    expect(task2.assignee).to eq(nil)
  end

  it "converts status from char representation to a :symbol and back" do
    task = Task.new
    expect(task.parse_status("+")).to eq(:completed)
    expect(task.parse_status(:completed)).to eq("+")
  end

  it "changes status" do
    task = Task.new("- create tasks.txt undefined")
    expect(task.change_status("create tasks.txt", :completed)).to eq(:completed)
  end

  it "changes assignee" do
    task = Task.new("- create tasks.txt Marsel")
    expect(task.change_assignee("create tasks.txt", "Roman")).to eq("Roman")
  end

  it "prepares a line to be written in to the todo file" do
    task = Task.new("- create tasks.txt Marsel")
    task.change_status("create tasks.txt", :completed)
    expect(task.line_for_file).to eq("+ create tasks.txt Marsel")
  end

  it "prepares a line to show on a display" do
    task = Task.new("- create tasks.txt Marsel")
    task.change_status("create tasks.txt", :completed)
    expect(task.line_for_display(3)).to eq("+ 3. task: create tasks.txt assignee: Marsel")
  end
end
