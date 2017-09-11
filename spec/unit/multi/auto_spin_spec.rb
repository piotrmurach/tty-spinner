# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#auto_spin' do
  let(:output) { StringIO.new('', 'w+') }

  it "doesn't auto spin top level spinner" do
    spinners = TTY::Spinner::Multi.new("Top level spinner", output: output)
    allow(spinners.top_spinner).to receive(:auto_spin)

    spinners.auto_spin

    expect(spinners.top_spinner).to_not have_received(:auto_spin)
  end

  it "raises an exception when called without a top spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)

    expect {
      spinners.auto_spin
    }.to raise_error(RuntimeError, /No top level spinner/)
  end

  it "auto spins top level & child spinners with jobs" do
    spinners = TTY::Spinner::Multi.new("top", output: output)
    jobs = []

    spinners.register("one") { |sp| jobs << 'one'; sp.success }
    spinners.register("two") { |sp| jobs << 'two'; sp.success }

    spinners.auto_spin

    expect(jobs).to match_array(['one', 'two'])
  end
end
