require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("Loading :spinner ...", format: :bouncing_ball)
spinner.auto_spin

sleep 1 # Some long task

spinner.stop('done')
