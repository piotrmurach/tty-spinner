# encoding: utf-8

require 'tty-spinner'
require 'pastel'

pastel = Pastel.new

format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("Task name")
spinner = TTY::Spinner.new(format, success_mark: pastel.green('+'), hide_cursor: true)
10.times do
  spinner.spin
  sleep(0.1)
end
spinner.success(pastel.green("(successful)"))
