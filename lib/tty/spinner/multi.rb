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

      def initialize(options = {})
        @options = options

        @create_spinner_lock = Mutex.new

        @spinners = []
        @callbacks = {
          success: [],
          error:   [],
          done:    [],
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
        end

        spinner
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

      def all_done?
        @spinners.all? { |s| s.done? }
      end

      def all_success?
        @spinners.all? { |s| s.succeeded? }
      end

      def any_error?
        @spinners.any? { |s| s.errored? }
      end

      def stop
        emit :done
      end

      def success
        stop
        emit :success
      end

      def error
        stop
        emit :error
      end

      def on(key, &block)
        raise "The event #{key} does not exist. Use :success, :error, or :done instead" unless @callbacks.key?(key)

        @callbacks[key].push(block)
      end

      private

      def emit(key)
        @callbacks[key].each do |method|
          method.call
        end
      end
    end # MultiSpinner
  end # Spinner
end # TTY
