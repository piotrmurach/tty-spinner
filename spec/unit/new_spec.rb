# coding: utf-8

RSpec.describe TTY::Spinner, '#new' do

  it "creates spinner with default format" do
    spinner = TTY::Spinner.new
    expect(spinner.format).to eq(:spin_1)
  end

  it "creates spinner with custom format" do
    spinner = TTY::Spinner.new("Initializing... :spinner ")
    expect(spinner.message).to eq("Initializing... :spinner ")
  end

  it "allows to set default output" do
    output = $stdout
    spinner = TTY::Spinner.new(output: output)
    expect(spinner.output).to eq(output)
  end
end
