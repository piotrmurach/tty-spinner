# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops all spinners and emits a success message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.done?).to eq(false)
    expect(sp2.done?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.stop

    expect(sp1.done?).to eq(true)
    expect(sp2.done?).to eq(true)
    expect(callbacks).to eq([:done])
  end

  it '#done? returns true when alls spinners are done' do
    spinners = TTY::Spinner::Multi.new(output: output)
    mock = double("spinner", add_multispinner: nil, :done? => true)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinners.register("")
    spinners.register("")

    expect(spinners.done?).to eq(true)
  end
end
