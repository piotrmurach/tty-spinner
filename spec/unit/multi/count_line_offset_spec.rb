# encoding: utf-8

RSpec.describe TTY::Spinner::Multi.new, '#count_line_offset' do
  let(:output) { StringIO.new('', 'w+') }

  it "does not count an unstarted spinner" do
    mock = double("TTY::Spinner",
      add_multispinner: nil,
      :spinning? => false,
      :success? => false,
      :error? => false,
      :done? => false
    )
    spinners = TTY::Spinner::Multi.new(output: output)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinners.register ""

    expect(spinners.count_line_offset(0)).to eq(0)
    expect(spinners.count_line_offset(99)).to eq(0)
  end

  it "counts a started spinner" do
    mock = double("TTY::Spinner", add_multispinner: nil, :spinning? => true)
    spinners = TTY::Spinner::Multi.new(output: output)
    allow(TTY::Spinner).to receive(:new).and_return(mock)

    spinners.register ""

    expect(spinners.count_line_offset(0)).to eq(1)
  end
end
