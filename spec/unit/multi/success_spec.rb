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

  it '#success? returns true when all spinners succeeded' do
    spinners = TTY::Spinner::Multi.new(output: output)
    mock = double("spinner", add_multispinner: nil, :succeeded? => true)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinners.register("")
    spinners.register("")

    expect(spinners.success?).to eq(true)
  end

  it '#success? returns false when a spinner has errored' do
    spinner = TTY::Spinner::Multi.new(output: output)
    mock = double("spinner", add_multispinner: nil)
    allow(mock).to receive(:succeeded?).and_return(true, false)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinner.register("")
    spinner.register("")

    expect(spinner.success?).to eq(false)
  end
end
