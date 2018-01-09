require_relative '../../lib/tty-spinner'

spinners = TTY::Spinner::Multi.new("[:spinner]")

sp1 = spinners.register("[:spinner] one")
sp2 = spinners.register("[:spinner] two")
sp3 = spinners.register("[:spinner] three")

sp1.auto_spin
sp2.auto_spin
sp3.auto_spin

sleep(1)

spinners.pause

sleep(1)

spinners.resume

sleep(1)

sp1.stop
sp2.stop
sp3.stop
spinners.stop
