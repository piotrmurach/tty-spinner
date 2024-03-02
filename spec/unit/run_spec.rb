RSpec.describe TTY::Spinner, "#run" do
  let(:output) { StringIO.new("", "w+") }

  it "runs animation while executing block" do
    spinner = TTY::Spinner.new(output: output, interval: 100)
    allow(spinner).to receive(:spin)
    spinner.run("done") { sleep(0.1) }
    expect(spinner).to have_received(:spin).at_least(5).times
  end

  it "runs animation and executes block within context" do
    context = spy("context")
    spinner = TTY::Spinner.new(":title", output: output)

    spinner.run("done") do
      context.call
      spinner.update(title: "executing")
    end

    expect(context).to have_received(:call).once
  end

  it "yields spinner instance when block argument is provided" do
    spinner = TTY::Spinner.new(":title", output: output)

    expect { |job|
      spinner.run("done", &job)
    }.to yield_with_args(spinner)
  end

  it "restores cursor when error is raised" do
    spinner = TTY::Spinner.new(output: output, hide_cursor: true)

    Thread.report_on_exception = false
    begin
      spinner.run do
        raise "boom"
      end
    rescue RuntimeError
    end
    Thread.report_on_exception = true

    output.rewind
    expect(output.read).to start_with("\e[?25l").and end_with("\e[?25h")
  end
end
