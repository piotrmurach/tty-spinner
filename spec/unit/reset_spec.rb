# coding: utf-8

RSpec.describe TTY::Spinner, '#reset' do
  let(:output) { StringIO.new('', 'w+') }

  it "spins default frames" do
    spinner = TTY::Spinner.new(output: output)
    5.times do |n|
      spinner.spin
      spinner.reset if n == 2
    end
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[1G|",
      "\e[1G/"
    ].join)
  end
end
