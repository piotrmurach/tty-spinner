# coding: utf-8

RSpec.describe TTY::Spinner, '#new' do

  it "creates spinner with default format" do
    spinner = TTY::Spinner.new
    expect(spinner.format).to eq(:spin_1)
  end

  it "allows to pass message in" do
    spinner = TTY::Spinner.new("Initializing...")
    expect(spinner.message).to eq("Initializing...")
  end

  it "allows to set default output" do
    output = $stdout
    spinner = TTY::Spinner.new(output: output)
    expect(spinner.output).to eq(output)
  end
end
