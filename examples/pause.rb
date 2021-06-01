# frozen_string_literal: true

require_relative "../lib/tty-spinner"

spinner = TTY::Spinner.new("[:spinner] :title")
spinner.update(title: "Task name")

spinner.auto_spin

sleep(2)

spinner.update(title: "Paused task name")
spinner.pause(mark: "?")

sleep(2)

spinner.resume
spinner.update(title: "Task name")

sleep(2)

spinner.stop("done...")

puts
