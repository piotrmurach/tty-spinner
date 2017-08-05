# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#auto_spin' do
  let(:output) { StringIO.new('', 'w+') }

  it "auto spins top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)
    allow_any_instance_of(TTY::Spinner).to receive(:auto_spin)

    spinners.auto_spin

    expect(spinners.top_spinner).to have_received(:auto_spin).once
  end

  it "raises an exception when called without a top spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)

    expect {
      spinners.auto_spin
    }.to raise_error(RuntimeError, /No top level spinner/)
  end
end
