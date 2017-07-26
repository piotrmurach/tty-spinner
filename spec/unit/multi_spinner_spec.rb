# coding: utf-8

RSpec.describe TTY::Spinner::Multi, '#register' do
  let(:output) { StringIO.new('', 'w+') }

  it "creates a TTY::Spinner" do
    spinner = TTY::Spinner::Multi.new(output: output, interval: 100)
    allow_any_instance_of(TTY::Spinner).to receive(:add_multispinner)
    expect_any_instance_of(TTY::Spinner).to receive(:add_multispinner)

    sp = spinner.register ""
    expect(sp).to be_instance_of TTY::Spinner
    expect(spinner.spinners.length).to eq(1)
  end
end

RSpec.describe TTY::Spinner::Multi, '#count_line_offset' do
  let(:output) { StringIO.new('', 'w+') }

  it "does not count an unstarted spinner" do
    mock = double "TTY::Spinner"
    allow(mock).to receive(:add_multispinner)
    allow(mock).to receive(:spinning?).and_return(false)
    allow(mock).to receive(:success?).and_return(false)
    allow(mock).to receive(:error?).and_return(false)
    allow(mock).to receive(:done?).and_return(false)
    spinner = TTY::Spinner::Multi.new(output: output)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinner.register ""

    expect(spinner.count_line_offset(0)).to eq(0)
  end

  it "counts a started spinner" do
    mock = double "TTY::Spinner"
    allow(mock).to receive(:add_multispinner)
    allow(mock).to receive(:spinning?).and_return(true)
    spinner = TTY::Spinner::Multi.new(output: output)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinner.register ""

    expect(spinner.count_line_offset(0)).to eq(1)
  end
end
