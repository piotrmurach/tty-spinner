require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new(":spinner :title", format: :pulse_3)

spinner.update(title: 'task aaaaa')

20.times { spinner.spin; sleep(0.1) }

spinner.update(title: 'task b')

20.times { spinner.spin; sleep(0.1) }
