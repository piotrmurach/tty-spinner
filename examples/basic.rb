# coding: utf-8

require 'tty-spinner'

spinner = TTY::Spinner.new("Loading ... ", format: :spin_2)
20.times do
  spinner.spin
  sleep(0.1)
end
spinner.stop
