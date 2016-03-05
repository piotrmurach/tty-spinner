# coding: utf-8

RSpec.describe TTY::Spinner, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it "stops after 2 spins" do
    spinner = TTY::Spinner.new(output: output)
    5.times do |n|
      spinner.spin
      spinner.stop if n == 1
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
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
      "\e[1GDone!"
    ].join)
  end

  it "stops after 2 spins with message and prints stop message" do
    message = "Loading ... "
    spinner = TTY::Spinner.new(message, output: output)
    5.times do |n|
      spinner.spin
      spinner.stop('Done!') if n == 1
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G#{message}|",
      "\e[1G#{message}/",
      "\e[1G#{message}Done!"
    ].join)
  end
end
