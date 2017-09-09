# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#error' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops registerd multi spinner and emits an :error message' do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.error?).to eq(false)
    expect(sp2.error?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.error

    expect(sp1.error?).to eq(true)
    expect(sp2.error?).to eq(true)
    expect(callbacks).to match_array([:done, :error])
  end

  it 'stops unregistered top level spinner and emits an :error message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.error?).to eq(false)
    expect(sp2.error?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.error

    expect(sp1.error?).to eq(true)
    expect(sp2.error?).to eq(true)
    expect(callbacks).to match_array([:done, :error])
  end

  it 'stops registed spinners under top level and emits an error message' do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.error?).to eq(false)
    expect(sp2.error?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.error
    sp2.error

    expect(spinners.error?).to eq(true)
    expect(callbacks).to match_array([:done, :error])
  end

  it 'stops registed spinners under top level and emits an error message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.error?).to eq(false)
    expect(sp2.error?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.error
    sp2.error

    expect(spinners.error?).to eq(true)
    expect(callbacks).to match_array([:done, :error])
  end

  it 'returns true when any spinner failed' do
    spinners = TTY::Spinner::Multi.new(output: output)
    sp1 = spinners.register("one")
    sp2 = spinners.register("two")

    sp1.success
    sp2.error

    expect(spinners.error?).to eq(true)
  end

  it "updates top spinner error state based on child spinners jobs failure" do
    spinners = TTY::Spinner::Multi.new("top", output: output)

    spinners.register("one") { |sp| sp.success }
    spinners.register("two") { |sp| sp.error }

    expect(spinners.error?).to eq(false)

    spinners.auto_spin

    expect(spinners.error?).to eq(true)
  end
end
