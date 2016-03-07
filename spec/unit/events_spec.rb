# coding: utf-8

RSpec.describe TTY::Spinner, 'events' do
  let(:output) { StringIO.new('', 'w+') }

  it "emits :done event" do
    events = []
    spinner = TTY::Spinner.new(output: output)
    spinner.on(:done) { events << :done }

    spinner.stop

    expect(events).to eq([:done])
  end

  it "emits :success event" do
    events = []
    spinner = TTY::Spinner.new(output: output)
    spinner.on(:done) { events << :done }
    spinner.on(:success) { events << :success }

    spinner.success

    expect(events).to match_array([:done, :success])
  end

  it "emits :error event" do
    events = []
    spinner = TTY::Spinner.new(output: output)
    spinner.on(:done) { events << :done }
    spinner.on(:error) { events << :error }

    spinner.error

    expect(events).to match_array([:done, :error])
  end
end
