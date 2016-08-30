# require_relative '../todo'
#
# RSpec.describe "todo" do
#   before(:each) do
#     @tasks = File.readlines("./spec/test_tasks.txt")
#     read_todo
#     dispatch
#   end
#
#   describe "read_todo method" do
#     it "parses todo file if file isn't empty" do
#       parsed = [
#         {status: :completed, task: "create tasks.txt", responsibility: "undefined"},
#         {status: :new, task: "create rspec tests", responsibility: "Marsel"},
#         {status: :in_progress, task: "create read_todo method", responsibility: "Marsel"}
#       ]
#       @tasks.each_with_index do |t,i|
#         expect(t[:status]).to eq(parsed[i][:status])
#         expect(t[:task]).to eq(parsed[i][:task])
#         expect(t[:responsibility]).to eq(parsed[i][:responsibility])
#       end
#     end
#   end
#
#   describe "add_task method" do
#     it "adds task to todo list with person argument" do
#       expect(add_task("add item", "Marsel")).to eq([
#         {status: :completed, responsibility: "undefined", task: "create tasks.txt"},
#         {status: :new, responsibility: "Marsel", task:  "create rspec tests"},
#         {status: :in_progress, responsibility: "Marsel", task: "create read_todo method"},
#         {status: :new, responsibility: "Marsel", task: "add item"}
#       ])
#     end
#     it "adds task to todo list without person argument" do
#       expect(add_task("add item")).to eq([
#         {status: :completed, responsibility: "undefined", task: "create tasks.txt"},
#         {status: :new, responsibility: "Marsel", task:  "create rspec tests"},
#         {status: :in_progress, responsibility: "Marsel", task: "create read_todo method"},
#         {status: :new, responsibility: "undefined", task: "add item"}
#       ])
#     end
#   end
#
#   it "removes task from todo list" do
#     expect(remove_task(2)).to eq({status: :new, responsibility: "Marsel", task:  "create rspec tests"})
#   end
#
#   it "changes responsibility person of one task" do
#     expect(change_solo_responsibility(1, "Marsel")).to eq("Marsel")
#   end
#
#   it "changes responsibility of all tasks by one person to another" do
#     expect(change_multi_responsibility("Marsel", "Roman")).to eq([
#       {status: :completed, responsibility: "undefined", task: "create tasks.txt"},
#       {status: :new, responsibility: "Roman", task:  "create rspec tests"},
#       {status: :in_progress, responsibility: "Roman", task: "create read_todo method"}
#     ])
#   end
#
#   it "writes todo list" do
#     expect(write_todo).to eq([
#       {status: :completed, responsibility: "undefined", task: "create tasks.txt"},
#       {status: :new, responsibility: "Marsel", task: "create rspec tests"},
#       {status: :in_progress, responsibility: "Marsel", task: "create read_todo method"}
#     ])
#   end
#
#   describe "change_status method" do
#     it "returns false if status is incorrect" do
#       expect(change_status(1, :finished)).to eq(false)
#     end
#
#     it "changes tasks status" do
#       expect(change_status(1, :pause)).to eq(:pause)
#     end
#   end
#
#   describe "parse_status method" do
#     it "converts + to :completed" do
#       expect(parse_status("+")).to eq(:completed)
#     end
#
#     it "converts :completed to +" do
#       expect(parse_status(:completed)).to eq("+")
#     end
#   end
# end
