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
    expect(task.change_status('completed')).to eq(:completed)
  end

  it "changes assignee" do
    task = Task.new("- create tasks.txt Marsel")
    expect(task.assign("Roman")).to eq("Roman")
  end

  it "prepares a line to be written in to the todo file" do
    task = Task.new("- create tasks.txt Marsel")
    task.change_status("completed")
    expect(task.line_for_file).to eq("+ create tasks.txt Marsel")
  end

  it "prepares a line to show on a display" do
    task = Task.new("- create tasks.txt Marsel")
    task.change_status("completed")
    expect(task.line_for_display(3)).to eq("+".color(:green) + " 3. task: create tasks.txt assignee: Marsel start time: ? total time: ?")
  end

  describe "time tracking" do
    before(:each) do
      @task = Task.new("- create time tracker Marsel")
      #Stub
      allow(Time).to receive(:now).and_return(100,200)
    end

    it "saves start time after starting the task" do
      @task.start
      expect(@task.start_time).to eq(100)
    end

    it "ignores second start" do
      2.times { @task.start }
      expect(@task.start_time).to eq(100)
    end

    it "updates total time after stopping the task" do
      @task.start
      @task.stop
      expect(@task.total_time).to eq(100)
    end

    it "sets start time to nil after stopping the task" do
      @task.start
      @task.stop
      expect(@task.start_time).to be_nil
    end

    it "ignores second stop" do
      @task.start
      @task.stop
      expect(-> { @task.stop }).not_to raise_exception
    end
  end
end
