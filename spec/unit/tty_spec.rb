# frozen_string_literal: true

RSpec.describe TTY::Spinner, "#tty?" do
  it "responds to tty?" do
    spinner = TTY::Spinner.new
    expect(spinner.tty?).to eq(true)
  end
end
