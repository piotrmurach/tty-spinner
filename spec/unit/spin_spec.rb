# coding: utf-8

RSpec.describe TTY::Spinner, '#spin' do
  let(:output) { StringIO.new('', 'w+') }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }

  it "spins default frames" do
    spinner = TTY::Spinner.new(output: output)

    expect(spinner.done?).to eq(false)

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
    spinner = TTY::Spinner.new(output: output, format: :spin)
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
    spinner = TTY::Spinner.new("Loading ... :spinner", output: output)
    4.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1GLoading ... |",
      "\e[1GLoading ... /",
      "\e[1GLoading ... -",
      "\e[1GLoading ... \\"
    ].join)
  end

  it "can spin and redraw indent" do
    multi_spinner = double("MultiSpinner")
    allow(multi_spinner).to receive(:count_line_offset).and_return(1, 1, 2, 1)
    allow(multi_spinner).to receive(:line_inset).and_return("--- ")

    spinner = TTY::Spinner.new(output: output)
    spinner.add_multispinner(multi_spinner, 0)
    spinner.spin
    spinner.redraw_indent

    output.rewind
    expect(output.read).to eq([
      "\e[1G--- |\n",
      save,
      "\e[1A",
      "--- ",
      restore,
    ].join)
  end

  it "spins with newline when it has a MultiSpinner" do
    multi_spinner = double("MultiSpinner")
    allow(multi_spinner).to receive(:count_line_offset).and_return(1, 1, 2, 1)
    allow(multi_spinner).to receive(:line_inset).and_return("")

    spinner = TTY::Spinner.new(":spinner one", output: output)
    spinner.add_multispinner(multi_spinner, 0)

    spinner2 = TTY::Spinner.new(":spinner two", output: output)
    spinner2.add_multispinner(multi_spinner, 1)

    spinner2.spin
    spinner.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n"
    ].join)

    spinner.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n",
      save,
      "\e[2A",          # up 2 lines
      "\e[1G/ one",
      restore
    ].join)

    spinner2.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n",
      save,
      "\e[2A",          # up 2 lines
      "\e[1G/ one",
      restore,
      save,
      "\e[1A",          # up 1 line
      "\e[1G/ two",
      restore
    ].join)
  end

  it "spins with many threads" do
    spinner = TTY::Spinner.new(output: output)

    th1 = Thread.new { 3.times { spinner.spin; sleep(0.05) } }
    th2 = Thread.new { 4.times { spinner.spin; sleep(0.05) } }

    [th1, th2].each(&:join)

    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[1G-",
      "\e[1G\\",
      "\e[1G|",
      "\e[1G/",
      "\e[1G-"
    ].join)
  end
end
