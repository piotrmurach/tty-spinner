# encoding: utf-8

RSpec.describe TTY::Spinner, '#update' do
  let(:output) { StringIO.new('', 'w+') }

  it "updates message content with custom token" do
    spinner = TTY::Spinner.new(":title :spinner", output: output, interval: 100)
    spinner.update(title: 'task')
    5.times { spinner.spin }
    spinner.stop('done')
    output.rewind
    expect(output.read).to eq([
      "\e[1Gtask |",
      "\e[1Gtask /",
      "\e[1Gtask -",
      "\e[1Gtask \\",
      "\e[1Gtask |",
      "\e[0m\e[2K",
      "\e[1Gtask | done\n"
    ].join)
  end

  it "updates message many times before stopping" do
    spinner = TTY::Spinner.new(":title :spinner", output: output)

    spinner.update(title: 'task_a')
    2.times { spinner.spin }
    spinner.update(title: 'task_b')
    2.times { spinner.spin }
    spinner.stop('done')
    output.rewind

    expect(output.read).to eq([
      "\e[1Gtask_a |",
      "\e[1Gtask_a /",
      "\e[0m\e[2K\e[1G",
      "\e[1Gtask_b -",
      "\e[1Gtask_b \\",
      "\e[0m\e[2K",
      "\e[1Gtask_b \\ done\n"
    ].join)
  end

  it "updates message after stopping" do
    spinner = TTY::Spinner.new(":title :spinner", output: output)

    spinner.update(title: 'task_a')
    2.times { spinner.spin }
    spinner.stop('done')

    spinner.start
    spinner.update(title: 'task_b')
    2.times { spinner.spin }
    spinner.stop('done')

    output.rewind
    expect(output.read).to eq([
      "\e[1Gtask_a |",
      "\e[1Gtask_a /",
      "\e[0m\e[2K",
      "\e[1Gtask_a / done\n",
      "\e[1Gtask_b |",
      "\e[1Gtask_b /",
      "\e[0m\e[2K",
      "\e[1Gtask_b / done\n"
    ].join)
  end

  it "maintains current tokens" do
    spinner = TTY::Spinner.new(":foo :bar", output: output)
    expect(spinner.tokens).to eq({})

    spinner.update(foo: 'FOO')
    spinner.update(bar: 'BAR')

    expect(spinner.tokens).to include({foo: 'FOO', bar: 'BAR'})
  end

  it "updates more than one token" do
    spinner = TTY::Spinner.new(":foo :bar", output: output)
    expect(spinner.tokens).to eq({})

    spinner.update(foo: 'FOO', bar: 'BAR')

    expect(spinner.tokens).to include({foo: 'FOO', bar: 'BAR'})
  end
end
