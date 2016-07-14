# coding: utf-8

RSpec.describe TTY::Spinner, '#join' do
  let(:output) { StringIO.new('', 'w+') }

  it "raises exception when not spinning" do
    spinner = TTY::Spinner.new(output: output)
    expect {
      spinner.join
    }.to raise_error(TTY::Spinner::NotSpinningError)
  end
end
