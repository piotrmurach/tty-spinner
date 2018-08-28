# coding: utf-8

RSpec.describe TTY::Spinner, '#run' do
  let(:output) { StringIO.new('', 'w+') }

  it "runs animation while executing block" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)
    spinner.run("done") { sleep(0.1) }
    expect(spinner).to have_received(:spin).at_least(5).times
  end

  it "runs animation and executes block within context" do
    context = spy('context')
    spinner = TTY::Spinner.new(":title", output: output)

    spinner.run("done") do
      context.call
      spinner.update(title: 'executing')
    end

    expect(context).to have_received(:call).once
  end

  it "yields spinner instance when block argument is provided" do
    spinner = TTY::Spinner.new(":title", output: output)

    expect { |job|
      spinner.run("done", &job)
    }.to yield_with_args(spinner)
  end
end
