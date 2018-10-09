# coding: utf-8

RSpec.describe TTY::Spinner::Multi, '#register' do
  let(:output) { StringIO.new('', 'w+') }

  it "registers a TTY::Spinner instance from a pattern" do
    spinners = TTY::Spinner::Multi.new(output: output, interval: 100)
    allow_any_instance_of(TTY::Spinner).to receive(:attach_to)
    expect_any_instance_of(TTY::Spinner).to receive(:attach_to)

    spinner = spinners.register ""

    expect(spinner).to be_instance_of(TTY::Spinner)
    expect(spinners.length).to eq(1)
  end

  it "registers a TTY::Spinner instance from a spinner instance" do
    spinners = TTY::Spinner::Multi.new(output: output, interval: 100)
    spinner_to_register = ::TTY::Spinner.new

    spinner = spinners.register spinner_to_register

    expect(spinner).to eq(spinner_to_register)
    expect(spinners.length).to eq(1)
  end

  it "raises an erro when given neither a string or spinner instance" do
    spinners = TTY::Spinner::Multi.new(output: output, interval: 100)

    expect { spinners.register [] }.
      to raise_error(
        ArgumentError,
        "Expected a pattern or spinner, got: Array"
      )
  end

  it "uses global options to register instance" do
    spinners = TTY::Spinner::Multi.new(output: output, interval: 100)
    spinner = double(:spinner, attach_to: nil)
    allow(spinner).to receive(:on).and_return(spinner)
    allow(TTY::Spinner).to receive(:new).and_return(spinner)

    spinners.register "[:spinner]"

    expect(TTY::Spinner).to have_received(:new).with("[:spinner]", {interval: 100, output: output})
  end
end
