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

  it "auto spins top level & child spinners with jobs" do
    spinners = TTY::Spinner::Multi.new("top", output: output)
    jobs = []

    spinners.register("one") { |sp| jobs << 'one'; sp.success }
    spinners.register("two") { |sp| jobs << 'two'; sp.success }

    expect(spinners.success?).to eq(false)

    spinners.auto_spin

    # Ensure that top level is successful as well if all jobs run
    # expect(spinners.success?).to eq(true)
    expect(jobs).to match_array(['one', 'two'])
  end
end
