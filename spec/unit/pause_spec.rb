RSpec.describe TTY::Spinner, "#pause" do
  let(:output) { StringIO.new("", "w+") }

  it "allows to pause auto spinning" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)

    spinner.auto_spin
    expect(spinner.paused?).to eq(false)

    sleep(0.02)

    spinner.pause
    expect(spinner.paused?).to eq(true)

    spinner.resume
    expect(spinner.paused?).to eq(true)

    spinner.stop

    expect(spinner).to have_received(:spin).at_least(1)
  end

  it "pauses auto-spin with a custom mark" do
    spinner = TTY::Spinner.new("[:spinner]", output: output)
    thread = spy(:thread)
    allow(Thread).to receive(:new).and_return(thread)
    spinner.auto_spin

    allow(spinner).to receive(:paused?).and_return(false)
    spinner.pause(mark: "?")
    allow(spinner).to receive(:paused?).and_return(true)
    spinner.resume
    spinner.auto_spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G[|]",
      "\e[1G[?]",
      "\e[1G[|]"
    ].join)
  end
end
