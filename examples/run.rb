require_relative '../lib/tty-spinner'

# without block
spinner = TTY::Spinner.new(":title :spinner ...", format: :pulse_3)

def long_task
  10000000.times do |n|
    n * n
  end
end

spinner.update(title: 'Task 1')
spinner.run 'done' do
  long_task
end

spinner.update(title: 'Task 2')
spinner.run('done') { long_task }
