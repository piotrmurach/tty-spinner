# coding: utf-8

require 'tty-spinner'

spinner = TTY::Spinner.new("Loading :spinner ...", format: :bouncing_ball)
spinner.start

sleep 1 # Some long task

spinner.stop('done')
