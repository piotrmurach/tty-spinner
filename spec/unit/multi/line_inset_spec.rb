# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#line_inset' do
  let(:output) { StringIO.new('', 'w+') }

  it "doesn't create inset when no top level spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)

    spinner = spinners.register 'example'

    expect(spinners.line_inset(spinner)).to eq('')
  end

  it "defaults to the empty string for the top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)

    expect(spinners.line_inset(1))
      .to eq(TTY::Spinner::Multi::DEFAULT_INSET[:top])
  end

  it "returns four spaces when there is a top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)

    spinners.register 'middle'
    spinners.register 'bottom'

    expect(spinners.line_inset(2))
      .to eq(TTY::Spinner::Multi::DEFAULT_INSET[:middle])
  end

  it "decorates last spinner" do
    spinners = TTY::Spinner::Multi.new("Top spinner", output: output)

    spinners.register 'middle'
    spinners.register 'bottom'

    expect(spinners.line_inset(3))
      .to eq(TTY::Spinner::Multi::DEFAULT_INSET[:bottom])
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
    spinners.register ""
    spinners.register ""

    expect(spinners.line_inset(1)).to eq(". ")
    expect(spinners.line_inset(2)).to eq("--")
    expect(spinners.line_inset(3)).to eq("---")
  end
end
