# frozen_string_literal: true

RSpec.describe TTY::Spinner, "#tty?" do
  it "responds to tty?" do
    spinner = TTY::Spinner.new
    expect(spinner).to respond_to(:tty?)
  end
end
