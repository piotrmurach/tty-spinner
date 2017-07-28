# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#success' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops all spinners and emits a success message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.succeeded?).to eq(false)
    expect(sp2.succeeded?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.success

    expect(sp1.succeeded?).to eq(true)
    expect(sp2.succeeded?).to eq(true)
    expect(callbacks).to eq([:success])
  end
end
