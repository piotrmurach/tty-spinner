require 'pastel'
require_relative '../../lib/tty-spinner'

pastel = Pastel.new
spinners = TTY::Spinner::Multi.new("[:spinner] Downloading files...")

['file1', 'file2', 'file3'].each do |file|
  spinners.register("[:spinner] #{file}") do |sp|
    sleep(rand * 5)
    sp.success(pastel.green("success"))
  end
end

spinners.auto_spin
