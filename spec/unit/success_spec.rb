# coding: utf-8

RSpec.describe TTY::Spinner, '#success' do
  let(:output) { StringIO.new('', 'w+') }

  it "marks spinner as success" do
    spinner = TTY::Spinner.new(output: output)
    3.times { spinner.spin }
    spinner.success
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[0m\e[2K",
      "\e[1G#{TTY::Spinner::TICK}\n"
    ].join)

    expect(spinner.success?).to eq(true)
  end

  it "marks spinner as success with message" do
    spinner = TTY::Spinner.new(output: output)
    3.times { spinner.spin }
    spinner.success('Successful')
    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[0m\e[2K",
      "\e[1G#{TTY::Spinner::TICK} Successful\n"
    ].join)

    expect(spinner.success?).to be(true)
  end

  it "changes success spinner marker" do
    spinner = TTY::Spinner.new(success_mark: '*', output: output)
    spinner.success('(successful)')
    output.rewind
    expect(output.read).to eq("\e[0m\e[2K\e[1G* (successful)\n")

    expect(spinner.success?).to be(true)
  end
end
