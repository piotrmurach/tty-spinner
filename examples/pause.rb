require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("[:spinner] Task name")

spinner.auto_spin

sleep(2)

spinner.pause

sleep(2)

spinner.resume

sleep(2)

spinner.stop

puts
