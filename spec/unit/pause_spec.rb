# encoding: utf-8

RSpec.describe TTY::Spinner, '#pause' do
  let(:output) { StringIO.new('', 'w+') }

  it "allows to pause auto spinning" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)

    spinner.auto_spin
    expect(spinner.paused?).to eq(false)

    sleep(0.02)

    spinner.pause
    expect(spinner.paused?).to eq(true)

    spinner.resume
    expect(spinner.paused?).to eq(true)

    spinner.stop

    expect(spinner).to have_received(:spin).at_least(1)
  end
end
