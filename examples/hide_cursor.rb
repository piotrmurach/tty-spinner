require 'pastel'
require_relative '../lib/tty-spinner'

pastel = Pastel.new

format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Task name")
spinner = TTY::Spinner.new(format, success_mark: pastel.green('+'), hide_cursor: true)
10.times do
  spinner.spin
  sleep(0.1)
end
spinner.success(pastel.green("(successful)"))
