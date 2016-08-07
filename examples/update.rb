# encoding: utf-8

require 'tty-spinner'

spinner = TTY::Spinner.new(":spinner :title", format: :pulse_3)

spinner.update(title: 'task aaaaa')

5.times { spinner.spin; sleep(0.1) }

spinner.update(title: 'task b')

5.times { spinner.spin; sleep(0.1) }
