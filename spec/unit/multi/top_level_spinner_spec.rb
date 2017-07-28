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
    spinners = TTY::Spinner::Multi.new(output: output, message: "Top level spinner")
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinners.register ""

    expect(spinners.line_inset(spinners.top_level_spinner)).to eq('')
  end

  it "returns four spaces when there is a top level spinner" do
    spinners = TTY::Spinner::Multi.new(output: output, message: "Top level spinner")
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinner = spinners.register ""

    expect(spinners.line_inset(spinner)).to eq('    ')
  end
end

RSpec.describe TTY::Spinner::Multi, '#auto_spin' do
  let(:output) { StringIO.new('', 'w+') }

  it "raises and exception when #auto_spin is called without a top level spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    spinners.register ""

    expect { spinners.auto_spin }.to raise_exception
  end

  it "doesn't raise exception" do
    spinners = TTY::Spinner::Multi.new(output: output, message: "Top level spinner")
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)
    allow_any_instance_of(TTY::Spinner).to receive(:auto_spin)

    spinners.register ""

    expect { spinners.auto_spin }.not_to raise_exception
  end

end
