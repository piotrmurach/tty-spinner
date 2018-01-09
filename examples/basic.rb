require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("Loading :spinner ... ", format: :spin_2)
20.times do
  spinner.spin
  sleep(0.1)
end
spinner.stop('done')
