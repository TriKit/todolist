require 'rainbow/ext/string'

def instruction
  puts "----------TO LIST-------------".color(:yellow)
  puts "Commands: ".color(:yellow)
  puts "add 'task'".color(:blue) + " - add task to todo list".color(:yellow)
  puts "add 'task' name".color(:blue) + " -  add task and name of responsible person".color(:yellow)
  puts "remove task_number".color(:blue) + " - remove task from todo list".color(:yellow)
  puts "change_status task_number status".color(:blue) + " - change tasks status".color(:yellow)
  puts "assign task_number person".color(:blue) + " - add responsible person if he was not previously appointed or reassign for one task".color(:yellow)
  puts "reassign previous_person new_person".color(:blue) + " - reassign responsible person for all tasks of other person".color(:yellow)
end


@tasks = File.readlines("tasks.txt")


def read_todo #class TodoList
  @tasks.map! do |i|
    hash = {}
    task_array = i.split(' ')
    hash[:status] = parse_status(task_array.shift)
    hash[:responsibility] = task_array.pop
    hash[:task] = task_array.join(' ')
    hash
  end
end

def parse_status(s, colorize: false) #class Task
  colors = { completed: :green, new: :red, in_progress: :orange, pause: :white }
  statuses = { completed: "+", new: "-", in_progress: "*", pause: "zzz" }
  result = if s.kind_of?(String)
    statuses.invert[s]
  else
    statuses[s]
  end
  colorize ? result.color(colors[s]) : result
end

def print_todo #class TodoList
  if @tasks.empty?
    instruction
  else
    @tasks.each_with_index do |t,i|
      print parse_status(t[:status], colorize: true)
      print " #{i+1}. "
      print "task: #{t[:task]}"
      print " responsibility: #{t[:responsibility]}\n"
    end
  end
end

def write_todo #class TodoList
  File.open("tasks.txt" ,"w+") do |f|
    @tasks.each do |l|
      f.print parse_status(l[:status])
      f.print " #{l[:task]}"
      f.print " #{l[:responsibility]}\n"
    end
  end
end

def dispatch #Global
  case ARGV[0]
  when "add"
    add_task(ARGV[1], ARGV[2])
  when "remove"
    remove_task(ARGV[1])
  when "change_status"
    change_status(ARGV[1], ARGV[2])
  when "assign"
    change_solo_responsibility(ARGV[1], ARGV[2])
  when "reassign"
    change_multy_responsibility(ARGV[1], ARGV[2])
  when "instruction"
    instruction
  end
end

def add_task(task, person=nil) #class TodoList
  @tasks << {status: :new, task: task, responsibility: person || "undefined" }
end

def remove_task(task_number) #class TodoList
  @tasks.delete_at(task_number.to_i - 1)
end

def change_status(task_number, status) #class Task
  status = status.to_sym
  [:completed, :new, :in_progress, :pause].include?(status)
  return false unless [:completed, :new, :in_progress, :pause].include?(status)
  @tasks[task_number.to_i - 1][:status] = status
end

def change_solo_responsibility(task_number, person) #class Task
  @tasks[task_number.to_i - 1][:responsibility] = person
end

def change_multi_responsibility(person1, person2) #class Task
  @tasks.each do |i|
    i[:responsibility] = person2 if i[:responsibility] == person1
  end
end
