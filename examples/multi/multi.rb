require_relative '../../lib/tty-spinner'

spinners = TTY::Spinner::Multi.new

sp1 = spinners.register "[:spinner] one"
sp2 = spinners.register "[:spinner] two"
sp3 = spinners.register "[:spinner] three"

sp1.auto_spin
sp2.auto_spin
sp3.auto_spin

sleep(2)

sp1.stop
sp2.stop
sp3.stop
