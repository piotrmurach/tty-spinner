# encoding: utf-8

require 'tty-spinner'

opts = {
  indent: 4,
  style: {
    top: "\u250c ",
    middle: "\u251c\u2500\u2500",
    bottom: "\u2514\u2500\u2500",
  }
}
spinners = TTY::Spinner::Multi.new("[:spinner] Top level spinner", opts)

sp1 = spinners.register "[:spinner] one"
sp2 = spinners.register "[:spinner] two"
sp3 = spinners.register "[:spinner] three"

spinners.auto_spin
sp1.auto_spin
sp2.auto_spin
sp3.auto_spin

sleep(2)

sp1.success
sleep 1
sp2.success

sleep 1

sp3.error

spinners.error
