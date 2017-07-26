require 'tty/spinner'

module TTY
  class Spinner
    # Used for managing multiple terminal spinners
    #
    # @api public
    class Multi
      attr_reader :spinners

      def initialize(options = {})
        @options = options

        @spinners = []
      end

      def register(message, options = {})
        new_spinner = TTY::Spinner.new(message, @options.merge(options))
        new_spinner.add_multispinner(self, @spinners.length)
        @spinners.push new_spinner

        new_spinner
      end

      # Used to calculate and return how many lines above the current cursor
      # position the spinner at a given index in the @spinners array can be
      # found
      def count_line_offset(index)
        count = 0
        @spinners.each_with_index do |spinner, i|
          next if i < index

          count += 1 if spinner.spinning? || spinner.success? || spinner.error? || spinner.done?
        end

        count
      end
    end # MultiSpinner
  end # Spinner
end # TTY
