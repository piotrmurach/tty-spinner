# coding: utf-8

require 'spec_helper'

RSpec.describe TTY::Spinner, '.spin' do
  let(:output) { StringIO.new('', 'w+') }

  it "spins default frames" do
    spinner = TTY::Spinner.new(output: output)
    5.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[1G\\",
      "\e[1G|"
    ].join)
  end

  it "spins chosen frame" do
    spinner = TTY::Spinner.new(output: output, format: :spin_3)
    5.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1G◴",
      "\e[1G◷",
      "\e[1G◶",
      "\e[1G◵",
      "\e[1G◴"
    ].join)
  end

  it "spins with message" do
    message = "Loading ... "
    spinner = TTY::Spinner.new(message, output: output)
    4.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1G#{message}|",
      "\e[1G#{message}/",
      "\e[1G#{message}-",
      "\e[1G#{message}\\"
    ].join)
  end
end
