# coding: utf-8

require 'tty-spinner'

TTY::Formats::FORMATS.size.times do |i|
  format = "spin_#{i+1}"
  spinner = TTY::Spinner.new("#{format}: ", format: format.to_sym,
                                            hide_cursor: true)
  20.times do
    spinner.spin
    sleep(0.1)
  end
  spinner.stop
  puts
end
