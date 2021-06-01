# frozen_string_literal: true

require_relative "../lib/tty-spinner"

spinner = TTY::Spinner.new("[:spinner] processing...", format: :bouncing_ball)

10.times do |i|
  spinner.log("[#{i}] Task")
  sleep(0.1)
  spinner.spin
end

spinner.success
