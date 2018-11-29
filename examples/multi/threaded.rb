# frozen_string_literal: true

require_relative '../../lib/tty-spinner'

def spinner_options
  [
    ":spinner \e[1mNo\e[0m :number Row :line",
    format: :dots,
    error_mark: '✖',
    success_mark: "\e[1m\e[32m✓\e[0m\e[0m"
  ]
end

spinners = TTY::Spinner::Multi.new(*spinner_options)
threads = []

20.times do |i|
  threads << Thread.new do
    spinner = spinners.register(*spinner_options)
    sleep Random.rand(0.1..0.3)

    10.times do
      sleep Random.rand(0.1..0.3)
      spinner.update(number: "(#{i})", line: spinner.row)
      spinner.spin
    end
  end
end

threads.each(&:join)
