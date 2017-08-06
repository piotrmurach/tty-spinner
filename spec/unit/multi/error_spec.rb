# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#error' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops all spinners and emits an error message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.error?).to eq(false)
    expect(sp2.error?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.error

    expect(sp1.error?).to eq(true)
    expect(sp2.error?).to eq(true)
    expect(callbacks).to eq([:error])
  end

  it '#error? returns true when any spinner failed' do
    spinners = TTY::Spinner::Multi.new(output: output)
    mock = double("spinner", add_multispinner: nil)
    allow(mock).to receive(:error?).and_return(true, false)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinners.register("one")
    spinners.register("two")

    expect(spinners.error?).to eq(true)
  end

  it "updates top spinner error state baed on child spinners jobs failure" do
    spinners = TTY::Spinner::Multi.new("top", output: output)

    spinners.register("one") { |sp| sp.success }
    spinners.register("two") { |sp| sp.error }

    expect(spinners.error?).to eq(false)

    spinners.auto_spin

    expect(spinners.error?).to eq(true)
  end
end
