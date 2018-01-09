# coding: utf-8

RSpec.describe TTY::Spinner, '#error' do
  let(:output) { StringIO.new('', 'w+') }

  it "marks spinner as error" do
    spinner = TTY::Spinner.new(output: output)
    3.times { spinner.spin }
    spinner.error
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[0m\e[2K",
      "\e[1G#{TTY::Spinner::CROSS}\n"
    ].join)

    expect(spinner.error?).to be(true)
  end

  it "marks spinner as error with message" do
    spinner = TTY::Spinner.new(output: output)
    3.times { spinner.spin }
    spinner.error('Error')
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[0m\e[2K",
      "\e[1G#{TTY::Spinner::CROSS} Error\n"
    ].join)

    expect(spinner.error?).to be(true)
  end

  it "changes error spinner marker" do
    spinner = TTY::Spinner.new(error_mark: 'x', output: output)
    spinner.error('(error)')
    output.rewind
    expect(output.read).to eq("\e[0m\e[2K\e[1Gx (error)\n")

    expect(spinner.error?).to be(true)
  end
end
