# coding: utf-8

require 'tty-spinner'

TTY::Formats::FORMATS.size.times do |i|
  format = "spin_#{i+1}"
  options = {format: format.to_sym, hide_cursor: true}
  spinner = TTY::Spinner.new("#{format}: :spinner", options)
  20.times do
    spinner.spin
    sleep(0.1)
  end
  spinner.stop
end
