# frozen_string_literal: true

RSpec.describe TTY::Formats::FORMATS do
  TTY::Formats::FORMATS.each do |token, properties|
    specify "#{token} contains proper defaults properties" do
      expect(properties.keys.sort).to eq(%i[frames interval])
    end
  end
end
