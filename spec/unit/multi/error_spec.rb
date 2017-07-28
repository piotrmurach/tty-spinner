# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#error' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops all spinners and emits an error message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.errored?).to eq(false)
    expect(sp2.errored?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.error

    expect(sp1.errored?).to eq(true)
    expect(sp2.errored?).to eq(true)
    expect(callbacks).to eq([:error])
  end
end
