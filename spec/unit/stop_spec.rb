# coding: utf-8

RSpec.describe TTY::Spinner, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it "doesn't reprint stop message" do
    spinner = TTY::Spinner.new(output: output)
    spinner.spin
    3.times { spinner.stop }
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[0m\e[2K",
      "\e[1G|\n",
    ].join)
  end

  it "stops after 2 spins" do
    spinner = TTY::Spinner.new(output: output)
    5.times do |n|
      spinner.spin
      spinner.stop if n == 1
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[0m\e[2K",
      "\e[1G/\n"
    ].join)
  end

  it "stops after 2 spins and prints stop message" do
    spinner = TTY::Spinner.new(output: output)
    5.times do |n|
      spinner.spin
      spinner.stop('Done!') if n == 1
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[0m\e[2K",
      "\e[1G/ Done!\n"
    ].join)

    expect(spinner.done?).to eq(true)
  end

  it "stops after 2 spins with message and prints stop message" do
    spinner = TTY::Spinner.new("Loading ... :spinner", output: output)
    5.times do |n|
      spinner.spin
      spinner.stop('Done!') if n == 1
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1GLoading ... |",
      "\e[1GLoading ... /",
      "\e[0m\e[2K",
      "\e[1GLoading ... / Done!\n"
    ].join)
  end
end
