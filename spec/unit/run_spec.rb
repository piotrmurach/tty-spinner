# coding: utf-8

RSpec.describe TTY::Spinner, '#run' do
  let(:output) { StringIO.new('', 'w+') }

  it "runs animation while executing block" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)
    spinner.run("done") { sleep(0.1) }
    expect(spinner).to have_received(:spin).at_least(5).times
  end
end
