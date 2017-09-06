# encoding: utf-8

RSpec.describe TTY::Spinner, '#job' do
  it "adds and executes job" do
    spinner = TTY::Spinner.new("[:spinner] :title")
    called = []
    work = proc { |sp| called << sp }
    spinner.job(&work)

    spinner.execute_job

    expect(called).to eq([spinner])
  end
end
