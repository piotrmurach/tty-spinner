require_relative '../../lib/tty-spinner'

spinners = TTY::Spinner::Multi.new("[:spinner] top")

spinners.register("[:spinner] one")   { |sp| sleep(2); sp.success('yes 2') }
spinners.register("[:spinner] two")   { |sp| sleep(3); sp.error('no 2') }
spinners.register("[:spinner] three") { |sp| sleep(1); sp.success('yes 3') }

spinners.auto_spin

