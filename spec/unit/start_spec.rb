# coding: utf-8

RSpec.describe TTY::Spinner, '#start' do
  let(:output) { StringIO.new('', 'w+') }

  it "starts automatic spinning" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)
    spinner.start
    sleep 0.1
    spinner.stop

    expect(spinner).to have_received(:spin).at_least(5).times
  end
end
