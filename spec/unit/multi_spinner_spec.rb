# coding: utf-8

RSpec.describe TTY::Spinner::Multi do
  describe '#count_line_offset' do
    let(:output) { StringIO.new('', 'w+') }

    it "does not count an unstarted spinner" do
      mock = double "TTY::Spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:spinning?).and_return(false)
      allow(mock).to receive(:success?).and_return(false)
      allow(mock).to receive(:error?).and_return(false)
      allow(mock).to receive(:done?).and_return(false)
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register ""

      expect(spinner.count_line_offset(0)).to eq(0)
    end

    it "counts a started spinner" do
      mock = double "TTY::Spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:spinning?).and_return(true)
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register ""

      expect(spinner.count_line_offset(0)).to eq(1)
    end
  end

  describe '#count_line_offset' do
    let(:output) { StringIO.new('', 'w+') }

    it "does not count an unstarted spinner" do
      mock = double "TTY::Spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:spinning?).and_return(false)
      allow(mock).to receive(:success?).and_return(false)
      allow(mock).to receive(:error?).and_return(false)
      allow(mock).to receive(:done?).and_return(false)
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register ""

      expect(spinner.count_line_offset(0)).to eq(0)
    end

    it "counts a started spinner" do
      mock = double "TTY::Spinner"
      allow(mock).to receive(:add_multispinner)
      allow(mock).to receive(:spinning?).and_return(true)
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(TTY::Spinner).to receive(:new).and_return(mock)

      spinner.register ""

      expect(spinner.count_line_offset(0)).to eq(1)
    end
  end

  describe '#on' do
    it 'registers method with a valid event' do
      spinner = TTY::Spinner::Multi.new(output: output)
      expect { spinner.on(:done) { true } }.not_to raise_exception
    end

    it 'refuses to register a method with an invalid event' do
      spinner = TTY::Spinner::Multi.new(output: output)
      expect { spinner.on(:not_a_real_event) { true } }.to raise_exception
    end
  end

  describe '#success' do
    it 'emits a success message' do
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(spinner).to receive(:emit)

      expect(spinner).to receive(:emit).with(:done).once
      expect(spinner).to receive(:emit).with(:success).once
      spinner.success
    end
  end

  describe '#error' do
    it 'emits an error message' do
      spinner = TTY::Spinner::Multi.new(output: output)
      allow(spinner).to receive(:emit)

      expect(spinner).to receive(:emit).with(:done).once
      expect(spinner).to receive(:emit).with(:error).once
      spinner.error
    end
  end

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
