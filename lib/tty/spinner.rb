# coding: utf-8

require 'tty/spinner/version'
require 'tty/spinner/formats'

module TTY
  # Used for creating terminal spinner
  #
  # @api public
  class Spinner
    include Formats
    ECMA_ESC = "\x1b".freeze
    ECMA_CSI = "\x1b[".freeze
    ECMA_CHA = 'G'.freeze

    DEC_RST = 'l'.freeze
    DEC_SET = 'h'.freeze
    DEC_TCEM = '?25'.freeze

    # The object that responds to print call defaulting to stderr
    #
    # @api public
    attr_reader :output

    # The current format type
    #
    # @return [String]
    #
    # @api public
    attr_reader :format

    # Whether to show or hide cursor
    #
    # @return [Boolean]
    #
    # @api public
    attr_reader :hide_cursor

    # The message to print before the spinner
    #
    # @return [String]
    #   the current message
    #
    # @api public
    attr_reader :message

    # Initialize a spinner
    #
    # @example
    #   spinner = TTY::Spinner.new
    #
    # @param [String] message
    #   the message to print in front of the spinner
    #
    # @param [Hash] options
    # @option options [String] :format
    #   the spinner format type defaulting to :spin_1
    # @option options [Object] :output
    #   the object that responds to print call defaulting to stderr
    # @option options [Boolean] :hide_cursor
    #   display or hide cursor
    #
    # @api public
    def initialize(*args)
      options  = args.last.is_a?(::Hash) ? args.pop : {}
      @message = args.empty? ? '' : args.pop

      @format      = options.fetch(:format) { :spin_1 }
      @output      = options.fetch(:output) { $stderr }
      @hide_cursor = options.fetch(:hide_cursor) { false }

      @frames      = options.fetch(:frames) { FORMATS[@format.to_sym] }
      @length      = @frames.length
      @current     = 0
      @done        = false
      @state       = :stopped
    end

    def spinning?
      @state == :spinning
    end

    def success?
      @state == :success
    end

    def failure?
      @state == :failure
    end

    # Perform a spin
    #
    # @return [String]
    #   the printed data
    #
    # @api public
    def spin
      return if @done

      if @hide_cursor && !spinning?
        write(ECMA_CSI + DEC_TCEM + DEC_RST)
      end

      data = message + @frames[@current]
      write(data, true)
      @current  = (@current + 1) % @length
      @state = :spinning
      data
    end

    # Finish spining
    #
    # @param [String] stop_message
    #   the stop message to print
    #
    # @api public
    def stop(stop_message = '')
      if @hide_cursor && spinning?
        write(ECMA_CSI + DEC_TCEM + DEC_SET, false)
      end
      @done = true
      @state = :success

      return if message.empty? && stop_message.empty?
      write(message + stop_message, true)
    end

    # Reset the spinner to initial frame
    #
    # @api public
    def reset
      @current = 0
      @state   = :stopped
    end

    private

    # Write data out to output
    #
    # @return [nil]
    #
    # @api private
    def write(data, clear_first = false)
      output.print(ECMA_CSI + '1' + ECMA_CHA) if clear_first
      output.print(data)
      output.flush
    end
  end # Spinner
end # TTY
