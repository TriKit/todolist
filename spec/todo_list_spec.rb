require_relative '../todo_list'
require_relative '../task'

RSpec.describe TodoList do
  before(:each) do
    @tasks = File.readlines('./todo_folder/test_tasks.txt')
    @todo_list = TodoList.new('test_tasks.txt')
    @task = Task.new('-,change tasks,undefined')
  end

  it 'reads txt file and creates tasks' do
    @todo_list.read_todo
    expect(@todo_list.tasks[0].description).to eq('change tasks')
  end

  it 'writes txt file with tasks' do
    @todo_list.read_todo
    @todo_list.add_task(@task)
    @todo_list.write_todo
    expect(@todo_list.tasks.last.description).to eq('change tasks')
    @todo_list.remove_task(3)
    @todo_list.write_todo
  end

  it 'adds tasks' do
    @todo_list.add_task(@task)
    expect(@todo_list.tasks).to include(@task)
  end

  it 'removes tasks' do
    task2 = Task.new('-,some new ******,undefined')
    @todo_list.add_task(@task)
    @todo_list.add_task(task2)
    @todo_list.remove_task(0)
    expect(@todo_list.tasks).to include(task2)
    expect(@todo_list.tasks).not_to include(@task)
  end
end
