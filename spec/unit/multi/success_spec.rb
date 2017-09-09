# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#success' do
  let(:output) { StringIO.new('', 'w+') }

  it 'stops registerd multi spinner and emits a :success message' do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.success?).to eq(false)
    expect(sp2.success?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.success

    expect(sp1.success?).to eq(true)
    expect(sp2.success?).to eq(true)
    expect(callbacks).to match_array([:success, :done])
  end

  it 'stops unregistered multi spinner and emits a :success message' do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.success?).to eq(false)
    expect(sp2.success?).to eq(false)

    spinners.on(:error)   { callbacks << :error }
            .on(:done)    { callbacks << :done }
            .on(:success) { callbacks << :success }

    spinners.success

    expect(sp1.success?).to eq(true)
    expect(sp2.success?).to eq(true)
    expect(callbacks).to match_array([:success, :done])
  end

  it "stops all registered spinners under top level and emits a :success message" do
    spinners = TTY::Spinner::Multi.new(":spinner", output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.success?).to eq(false)
    expect(sp2.success?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.success
    sp2.success

    expect(spinners.success?).to eq(true)
    expect(callbacks).to match_array([:success, :done])
  end

  it "stops all registered spinners and emits a success message" do
    spinners = TTY::Spinner::Multi.new(output: output)
    callbacks = []
    sp1 = spinners.register "[:spinner] one"
    sp2 = spinners.register "[:spinner] two"

    expect(sp1.success?).to eq(false)
    expect(sp2.success?).to eq(false)

    spinners.on(:error) { callbacks << :error }
            .on(:done) { callbacks << :done }
            .on(:success) { callbacks << :success }

    sp1.success
    sp2.success

    expect(spinners.success?).to eq(true)
    expect(callbacks).to match_array([:success, :done])
  end

  it 'returns false when a spinner has errored' do
    spinners = TTY::Spinner::Multi.new(output: output)

    sp1 = spinners.register("")
    sp2 = spinners.register("")

    sp1.success
    sp2.error

    expect(spinners.success?).to eq(false)
  end

  it "updates top spinner success state based on child spinners jobs status" do
    spinners = TTY::Spinner::Multi.new("top", output: output)

    spinners.register("one") { |sp| sp.success }
    spinners.register("two") { |sp| sp.success }

    expect(spinners.success?).to eq(false)

    spinners.auto_spin

    expect(spinners.success?).to eq(true)
  end
end
