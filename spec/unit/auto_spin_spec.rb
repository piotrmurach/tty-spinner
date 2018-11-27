# coding: utf-8

RSpec.describe TTY::Spinner, '#auto_spin' do
  let(:output) { StringIO.new('', 'w+') }

  it "starts and auto spins" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)

    spinner.auto_spin
    sleep 0.1
    spinner.stop

    expect(spinner).to have_received(:spin).at_least(5).times
  end

  it "restores cursor when erorr is raised" do
    spinner = TTY::Spinner.new(output: output, hide_cursor: true)

    spinner.auto_spin {
      raise 'boom'
    }

    output.rewind
    expect(output.read).to start_with("\e[?25l").and end_with("\e[?25h")
  end
end
