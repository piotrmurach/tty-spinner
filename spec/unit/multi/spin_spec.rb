# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#spin' do
  let(:output) { StringIO.new('', 'w+') }
  let(:save)    { TTY::Cursor.save }
  let(:restore) { TTY::Cursor.restore }
  let(:top) { TTY::Spinner::Multi::DEFAULT_INSET[:top] }
  let(:middle) { TTY::Spinner::Multi::DEFAULT_INSET[:middle] }
  let(:bottom) { TTY::Spinner::Multi::DEFAULT_INSET[:bottom] }

  it "spins spinners correctly under multi spinner" do
    spinners = TTY::Spinner::Multi.new(output: output)

    spinner1 = spinners.register(":spinner one")
    spinner2 = spinners.register(":spinner two")

    spinner2.spin
    spinner1.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n"
    ].join)

    spinner1.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n",
      save,
      "\e[1A",          # up 1 line
      "\e[1G/ one",
      restore
    ].join)

    spinner2.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G| two\n",
      "\e[1G| one\n",
      save,
      "\e[1A",          # up 1 line
      "\e[1G/ one",
      restore,
      save,
      "\e[2A",          # up 2 lines
      "\e[1G/ two",
      restore
    ].join)
  end

  it "spins registerd spinners correctly under top level multi spinner" do
    spinners = TTY::Spinner::Multi.new(":spinner top", output: output)

    spinner1 = spinners.register(":spinner one")
    spinner2 = spinners.register(":spinner two")

    spinners.spin

    spinner2.spin
    spinner1.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}| top\n",
      "\e[1G#{middle}| two\n",
      "\e[1G#{bottom}| one\n"
    ].join)

    spinner1.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}| top\n",
      "\e[1G#{middle}| two\n",
      "\e[1G#{bottom}| one\n",
      save,
      "\e[1A",          # up 1 line
      "\e[1G#{bottom}/ one",
      restore
    ].join)

    spinner2.spin

    output.rewind
    expect(output.read).to eq([
      "\e[1G#{top}| top\n",
      "\e[1G#{middle}| two\n",
      "\e[1G#{bottom}| one\n",
      save,
      "\e[1A",          # up 1 line
      "\e[1G#{bottom}/ one",
      restore,
      save,
      "\e[2A",          # up 2 lines
      "\e[1G#{middle}/ two",
      restore
    ].join)
  end
end
