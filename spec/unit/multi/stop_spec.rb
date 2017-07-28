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
end
