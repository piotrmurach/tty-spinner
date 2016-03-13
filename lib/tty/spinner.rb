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
    ECMA_CLR = 'K'.freeze

    DEC_RST = 'l'.freeze
    DEC_SET = 'h'.freeze
    DEC_TCEM = '?25'.freeze

    MATCHER = /:spinner/.freeze
    TICK = '✔'.freeze
    CROSS = '✖'.freeze

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
    # @option options [Boolean] :clear
    #   clear ouptut when finished
    # @option options [Float] :interval
    #   the interval for auto spinning
    #
    # @api public
    def initialize(*args)
      options  = args.last.is_a?(::Hash) ? args.pop : {}
      @message = args.empty? ? ':spinner' : args.pop

      @format      = options.fetch(:format) { :classic }
      @output      = options.fetch(:output) { $stderr }
      @hide_cursor = options.fetch(:hide_cursor) { false }
      @frames      = options.fetch(:frames) { fetch_frames(@format.to_sym) }
      @clear       = options.fetch(:clear) { false }
      @success_mark= options.fetch(:success_mark) { TICK }
      @error_mark  = options.fetch(:error_mark) { CROSS }
      @interval    = options.fetch(:interval) { 0.1 }

      @callbacks   = Hash.new { |h, k| h[k] = [] }
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

    def error?
      @state == :error
    end

    # Register callback
    #
    # @api public
    def on(name, &block)
      @callbacks[name] << block
      self
    end

    # Start automatic spinning
    #
    #
    # @api public
    def start
      @started_at = Time.now

      @thread = Thread.new do
        while @started_at do
          spin
          sleep(@interval)
        end
      end
    end

    def duration
      @started_at ? Time.now - @started_at : nil
    end

    # Join running spinner
    #
    # @param [Float] timeout
    #   the timeout for join
    #
    # @api public
    def join(timeout = nil)
      fail NotSpinningError.new(
        "Cannot join spinner that is not running"
      ) unless @thread

      timeout ? @thread.join(timeout) : @thread.join
    end

    # Kill running spinner
    #
    # @api public
    def kill
      @thread.kill if @thread
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

      data = message.gsub(MATCHER, @frames[@current])
      write(data, true)
      @current = (@current + 1) % @length
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
      @started_at = nil
      emit(:done)
      return clear_line if @clear

      char = if success?
               @success_mark
             elsif error?
               @error_mark
             else
               @frames[@current - 1]
             end
      data = message.gsub(MATCHER, char)

      if !stop_message.empty?
        data << ' ' + stop_message
      end

      write(data, true)
      write("\n", false) unless @clear
      reset
    end

    # Finish spinning and set state to :success
    #
    # @api public
    def success(stop_message = '')
      @state = :success
      stop(stop_message)
      emit(:success)
    end

    # Finish spinning and set state to :error
    #
    # @api public
    def error(stop_message = '')
      @state = :error
      stop(stop_message)
      emit(:error)
    end

    # Clear current line
    #
    # @api public
    def clear_line
      output.print(ECMA_CSI + '0m' + ECMA_CSI + '1000D' + ECMA_CSI + ECMA_CLR)
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

    # Emit callback
    #
    # @api private
    def emit(name, *args)
      @callbacks[name].each do |block|
        block.call(*args)
      end
    end

    # Find frames by token name
    #
    # @param [Symbol] token
    #   the name for the frames
    #
    # @return [Array, String]
    #
    # @api private
    def fetch_frames(token)
      if FORMATS.key?(token)
        FORMATS[token][:frames]
      else
        raise ArgumentError, "Unknown format token `:#{token}`"
      end
    end
  end # Spinner
end # TTY
