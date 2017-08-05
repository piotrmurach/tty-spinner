# coding: utf-8
#

RSpec.describe TTY::Spinner::Multi, '#line_inset' do
  let(:output) { StringIO.new('', 'w+') }

  it "returns the empty string when there's no top level spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinner = spinners.register ""

    expect(spinners.line_inset(spinner)).to eq('')
  end

  it "returns the empty string for the top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinners.register ""

    expect(spinners.line_inset(spinners.top_spinner)).to eq('')
  end

  it "returns four spaces when there is a top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinner = spinners.register ""

    expect(spinners.line_inset(spinner)).to eq("  ")
  end

  it "defaults to the empty string for the top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner")

    expect(spinners.line_inset(spinners.top_spinner)).to eq('')
  end

  it "allows customization" do
    opts = {
        output: output,
        indent: 4,
        style: {
          top: ". ",
          middle: "--",
          bottom: "---",
        }
      }
    spinners = TTY::Spinner::Multi.new("Top level spinner", opts)
    middle_spinner = spinners.register ""
    bottom_spinner = spinners.register ""

    expect(spinners.line_inset(spinners.top_spinner)).to eq(". ")
    expect(spinners.line_inset(middle_spinner)).to eq("--  ")
    expect(spinners.line_inset(bottom_spinner)).to eq("--- ")
  end
end
