# frozen_string_literal: true

require_relative "../../lib/tty-spinner"
require "pastel"

@pastel = Pastel.new

def spinner_text
  ":spinner #{@pastel.bold('No')} :number \t #{@pastel.bold('Row')} :line"
end

def spinner_options
  {
    format: :dots,
    hide_cursor: true,
    error_mark: @pastel.red.bold("✖"),
    success_mark: @pastel.green.bold("✓")
  }
end

spinners = TTY::Spinner::Multi.new(spinner_text, **spinner_options)
threads = []

20.times do |i|
  threads << Thread.new do
    spinner = spinners.register(spinner_text, **spinner_options)
    sleep Random.rand(0.1..0.3)

    10.times do
      sleep Random.rand(0.1..0.3)
      spinner.update(number: "(#{i})", line: spinner.row)
      spinner.spin
    end

    # Randomize conclusion
    conclusion = %i[success error].sample
    spinner.send(conclusion)
  end
end

threads.each(&:join)
