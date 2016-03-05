# encoding: utf-8

RSpec.describe TTY::Spinner, ':frames' do
  let(:output) { StringIO.new('', 'w+') }

  it "uses custom frames from string" do
    frames = ".o0@*"
    spinner = TTY::Spinner.new(frames: frames, output: output)
    5.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1G.",
      "\e[1Go",
      "\e[1G0",
      "\e[1G@",
      "\e[1G*"
    ].join)
  end

  it "uses custom frames from array" do
    frames = [".", "o", "0", "@", "*"]
    spinner = TTY::Spinner.new(frames: frames, output: output)
    5.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1G.",
      "\e[1Go",
      "\e[1G0",
      "\e[1G@",
      "\e[1G*"
    ].join)
  end
end
