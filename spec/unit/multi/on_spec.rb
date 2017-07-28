# encoding: utf-8

RSpec.describe TTY::Spinner::Multi, '#on' do
  let(:output) { StringIO.new('', 'w+') }

  it 'fails to register a callback with invalid event name' do
    spinners = TTY::Spinner::Multi.new(output: output)

    expect {
      spinners.on(:unknown_event) { }
    }.to raise_error(ArgumentError, /The event unknown_event does not exist/)
  end
end
