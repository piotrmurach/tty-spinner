# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#stop' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops unregisterd multi spinner and emits a :done message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.done?).to eq(false)
    expect(sp2.done?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.stop

    expect(sp1.done?).to eq(true)
    expect(sp2.done?).to eq(true)
    expect(callbacks).to eq([:done])
  end

  it 'stops registerd multi spinner and emits a :done message' do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.done?).to eq(false)
    expect(sp2.done?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.stop

    expect(sp1.done?).to eq(true)
    expect(sp2.done?).to eq(true)
    expect(callbacks).to eq([:done])
  end

  it 'stops all registered spinners and emits a :done message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.done?).to eq(false)
    expect(sp2.done?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.stop
    sp2.stop

    expect(spinners.done?).to eq(true)
    expect(callbacks).to eq([:done])
  end

  it 'stops all registered spinners under multispinner and emits a :done message' do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.done?).to eq(false)
    expect(sp2.done?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.stop
    sp2.stop

    expect(spinners.done?).to eq(true)
    expect(callbacks).to eq([:done])
  end

  it 'returns true when spinner is done' do
    spinners = TTY::Spinner::Multi.new(output: output)

    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    sp1.stop
    sp2.error

    expect(spinners.done?).to eq(true)
  end
end
