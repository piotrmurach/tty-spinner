# encoding: utf-8
# frozen_string_literal: true

require 'forwardable'

require_relative '../spinner'

module TTY
  class Spinner
    # Used for managing multiple terminal spinners
    #
    # @api public
    class Multi
      include Enumerable

      extend Forwardable

      def_delegators :@spinners, :each, :empty?, :length

      DEFAULT_INSET = {
        top: '',
        middle: '  ',
        bottom: '  '
      }.freeze

      # Initialize a multispinner
      #
      # @example
      #   spinner = TTY::Spinner::Multi.new
      #
      # @param [String] message
      #   the optional message to print in front of the top level spinner
      #
      # @param [Hash] options
      # @option options [Hash] :style
      #   keys :top :middle and :bottom can contain Strings that are used to
      #   indent the spinners. Ignored if message is blank
      # @option options [Object] :output
      #   the object that responds to print call defaulting to stderr
      # @option options [Boolean] :hide_cursor
      #   display or hide cursor
      # @option options [Boolean] :clear
      #   clear ouptut when finished
      # @option options [Float] :interval
      #   the interval for auto spinning
      #
      # @api public
      def initialize(*args)
        @options = args.last.is_a?(::Hash) ? args.pop : {}
        message = args.empty? ? nil : args.pop
        @inset_opts = @options.delete(:style) { DEFAULT_INSET }
        @create_spinner_lock = Mutex.new
        @spinners    = []
        @top_spinner = nil
        unless message.nil?
          @top_spinner = register(message)
        end

        @callbacks = {
          success: [],
          error:   [],
          done:    []
        }
      end

      # Register a new spinner
      #
      # @param [String] pattern
      #   the pattern used for creating spinner
      #
      # @api public
      def register(pattern, options = {})
        spinner = TTY::Spinner.new(pattern, @options.merge(options))

        @create_spinner_lock.synchronize do
          spinner.add_multispinner(self, @spinners.length)
          @spinners << spinner
          @spinners.each { |sp| sp.redraw_indent if sp.spinning? || sp.done? } unless @top_spinner.nil?
        end

        spinner
      end

      # Get the top level spinner if it exists
      #
      # @return [TTY::Spinner] the top level spinner
      #
      # @api public
      def top_spinner
        raise "No top level spinner" if @top_spinner.nil?

        @top_spinner
      end

      # Auto spin the top level spinner
      #
      # @api public
      def auto_spin
        raise "No top level spinner" if @top_spinner.nil?

        @top_spinner.auto_spin
      end

      # Find relative offset position to which to move the current cursor
      #
      # The position is found among the registered spinners given the current
      # position the spinner is at provided its index
      #
      # @param [Integer] index
      #   the position to search from
      #
      # @return [Integer]
      #   the current position
      #
      # @api public
      def count_line_offset(index)
        Array(@spinners[index..-1]).reduce(0) do |acc, spinner|
          if spinner.spinning? || spinner.success? ||
             spinner.error? || spinner.done?
            acc += 1
          end
          acc
        end
      end

      # Find the number of characters to move into the line
      # before printing the spinner
      #
      # @param [TTY::Spinner] spinner
      #   the spinner for which line inset is calculated
      #
      # @return [String]
      #   the inset
      #
      # @api public
      def line_inset(spinner)
        return '' if @top_spinner.nil?

        case spinner
        when @top_spinner
          @inset_opts[:top]
        when @spinners.last
          @inset_opts[:bottom]
        else
          @inset_opts[:middle]
        end
      end

      # Check if all spinners are done
      #
      # @return [Boolean]
      #
      # @api public
      def done?
        @spinners.all?(&:done?)
      end

      # Check if all spinners succeeded
      #
      # @return [Boolean]
      #
      # @api public
      def success?
        @spinners.all?(&:succeeded?)
      end

      # Check if any spinner errored
      #
      # @return [Boolean]
      #
      # @api public
      def error?
        @spinners.any?(&:errored?)
      end

      # Stop all spinners
      #
      # @api public
      def stop
        @spinners.dup.each(&:stop)
        emit :done
      end

      # Stop all spinners with success status
      #
      # @api public
      def success
        @top_spinner.success if @top_spinner
        @spinners.dup.each(&:success)
        emit :success
      end

      # Stop all spinners with error status
      #
      # @api public
      def error
        @top_spinner.error if @top_spinner
        @spinners.dup.each(&:error)
        emit :error
      end

      # Listen on event
      #
      # @api public
      def on(key, &callback)
        unless @callbacks.key?(key)
          raise ArgumentError, "The event #{key} does not exist. "\
                               " Use :success, :error, or :done instead"
        end
        @callbacks[key] << callback
        self
      end

      private

      def emit(key, *args)
        @callbacks[key].each do |block|
          block.call(*args)
        end
      end
    end # MultiSpinner
  end # Spinner
end # TTY
