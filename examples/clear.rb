require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("[:spinner] Task name", format: :bouncing_ball)
20.times do
  spinner.spin
  sleep(0.1)
end

spinner.success
