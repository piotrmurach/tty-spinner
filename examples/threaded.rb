require_relative '../lib/tty-spinner'

spinner = TTY::Spinner.new("[:spinner]")

th1 = Thread.new { 10.times { spinner.spin; sleep(0.1) } }
th2 = Thread.new { 10.times { spinner.spin; sleep(0.1) } }
th3 = Thread.new { 10.times { spinner.spin; sleep(0.1) } }

[th1, th2, th3].each(&:join)

spinner.success
