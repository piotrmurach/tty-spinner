require_relative '../../lib/tty-spinner'

spinners = TTY::Spinner::Multi.new "[:spinner] main", format: :pulse

sp1 = spinners.register "[:spinner] one", format: :classic
sp2 = spinners.register "[:spinner] two", format: :classic
sp3 = spinners.register "[:spinner] three", format: :classic

th1 = Thread.new { 20.times { sleep(0.2); sp1.spin }}
th2 = Thread.new { 30.times { sleep(0.1); sp2.spin }}
th3 = Thread.new { 10.times { sleep(0.3); sp3.spin }}

[th1, th2, th3].each(&:join)
