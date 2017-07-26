require 'tty-spinner'

spinners = TTY::Spinner::Multi.new(hide_cursor: true)

sp1 = spinners.register "[:spinner] Hello World!"
sp2 = spinners.register "[:spinner] Hello World 2!"
sp1.auto_spin

sleep 2

sp2.auto_spin

sleep 3

sp2.success

sleep 2

sp1.error

