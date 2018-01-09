require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("[:spinner] Task name")
20.times do
  spinner.spin
  sleep(0.1)
end

spinner.error('(error)')
