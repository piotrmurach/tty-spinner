RSpec.describe TTY::Spinner, "#log" do
  let(:output) { StringIO.new("", "w+") }

  it "logs a message above a spinner" do
    spinner = TTY::Spinner.new(output: output)

    2.times {
      spinner.log "foo\nbar"
      spinner.spin
    }
    output.rewind

    expect(output.read).to eq([
      "\e[2K\e[1Gfoo\n",
      "\e[2K\e[1Gbar\n",
      "\e[1G|",
      "\e[1G|",
      "\e[2K\e[1Gfoo\n",
      "\e[2K\e[1Gbar\n",
      "\e[1G/",
      "\e[1G/"
    ].join)
  end

  it "logs a message ending with a newline above a spinner" do
    spinner = TTY::Spinner.new(output: output)

    2.times {
      spinner.log "foo\n"
      spinner.spin
    }
    output.rewind

    expect(output.read).to eq([
      "\e[2K\e[1Gfoo\n",
      "\e[1G|",
      "\e[1G|",
      "\e[2K\e[1Gfoo\n",
      "\e[1G/",
      "\e[1G/"
    ].join)
  end

  it "logs message under a spinner when done" do
    spinner = TTY::Spinner.new(output: output)
    2.times { spinner.spin }
    spinner.stop

    spinner.log "foo\nbar"

    output.rewind
    expect(output.read).to eq([
      "\e[1G|",
      "\e[1G/",
      "\e[0m\e[2K\e[1G/\n",
      "\e[2K\e[1Gfoo\n",
      "\e[2K\e[1Gbar\n"
    ].join)
  end

  context "when trailing_newline is false" do
    it "logs a message above a spinner" do
      spinner = TTY::Spinner.new(output: output)

      2.times do
        spinner.log "foo\r", trailing_newline: false
        spinner.spin
      end
      output.rewind

      expect(output.read).to eq([
        "\e[2K\e[1Gfoo\r",
        "\e[1G|",
        "\e[1G|",
        "\e[2K\e[1Gfoo\r",
        "\e[1G/",
        "\e[1G/"
      ].join)
    end
  end
end
