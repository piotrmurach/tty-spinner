# coding: utf-8

RSpec.describe TTY::Spinner::Multi, '#register' do
  let(:output) { StringIO.new('', 'w+') }

  it "registers a TTY::Spinner instance" do
    spinners = TTY::Spinner::Multi.new(output: output, interval: 100)
    allow_any_instance_of(TTY::Spinner).to receive(:attach_to)
    expect_any_instance_of(TTY::Spinner).to receive(:attach_to)

    spinner = spinners.register ""

    expect(spinner).to be_instance_of(TTY::Spinner)
    expect(spinners.length).to eq(1)
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
