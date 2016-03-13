# coding: utf-8

require 'tty-spinner'

spinner = TTY::Spinner.new("Loading :spinner ...", format: :spin_2)
spinner.start

sleep 1 # Some long task

spinner.stop('done')
