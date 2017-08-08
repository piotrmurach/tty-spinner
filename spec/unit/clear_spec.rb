# encoding: utf-8

RSpec.describe TTY::Spinner, ':clear' do
  let(:output) { StringIO.new('', 'w+') }

  it "clears output when done" do
    spinner = TTY::Spinner.new(clear: true, output: output)
    3.times { spinner.spin }
    spinner.stop('Done!')
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[0m\e[2K\e[1G"
    ].join)
  end
end
