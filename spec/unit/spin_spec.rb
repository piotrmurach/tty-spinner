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
    allow(multi_spinner).to receive(:synchronize).and_yield
    allow(multi_spinner).to receive(:next_row).and_return(1)
    allow(multi_spinner).to receive(:rows).and_return(1)
    allow(multi_spinner).to receive(:line_inset).and_return("--- ")

    spinner = TTY::Spinner.new(output: output)
    spinner.attach_to(multi_spinner)
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
