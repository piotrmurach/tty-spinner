# coding: utf-8

RSpec.describe TTY::Spinner::Multi do
  describe 'end state functions' do
    it '#all_success? returns true when all spinners succeeded' do
      spinner = TTY::Spinner::Multi.new(output: output)
      mock = double "spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:succeeded?).and_return true
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register("")
      spinner.register("")

      expect(spinner.all_success?).to eq(true)
    end

    it '#all_success? returns false when a spinner has errored' do
      spinner = TTY::Spinner::Multi.new(output: output)
      mock = double "spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:succeeded?).and_return(true, false)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register("")
      spinner.register("")

      expect(spinner.all_success?).to eq(false)
    end

    it '#any_error? returns true when all spinners succeeded' do
      spinner = TTY::Spinner::Multi.new(output: output)
      mock = double "spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:errored?).and_return(true, false)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register("")
      spinner.register("")

      expect(spinner.any_error?).to eq(true)
    end
  end

  describe '#emit' do
    it 'calls the provided callbacks' do
      spinner = TTY::Spinner::Multi.new(output: output)
      mock = double "callback"
      allow(mock).to receive(:method)
      expect(mock).to receive(:method)
      spinner.on(:done) { mock.method }

      spinner.stop
    end
  end
end
