# coding: utf-8

RSpec.describe TTY::Spinner, '#spin' do
  let(:output) { StringIO.new('', 'w+') }
  let(:save) { Gem.win_platform? ? "\e[s" : "\e7" }
  let(:restore) { Gem.win_platform? ? "\e[u" : "\e8" }


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

    spinner = TTY::Spinner.new(output: output, interval: 100)
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

    spinner = TTY::Spinner.new(output: output, interval: 100)
    spinner.add_multispinner(multi_spinner, 0)

    spinner2 = TTY::Spinner.new(output: output, interval: 100)
    spinner2.add_multispinner(multi_spinner, 1)

    spinner.spin
    spinner2.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G|\n",
      "\e[1G|\n"].join)

    spinner.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G|\n",
      "\e[1G|\n",
      save,
      "\e[2A",          # up 2 lines
      "\e[1G/",
      restore
    ].join)

    spinner2.spin
    output.rewind
    expect(output.read).to eq([
      "\e[1G|\n",
      "\e[1G|\n",
      save,
      "\e[2A",          # up 2 lines
      "\e[1G/",
      restore,
      save,
      "\e[1A",          # up 1 line
      "\e[1G/",
      restore
    ].join)

  end
end
