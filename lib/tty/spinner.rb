# coding: utf-8

require 'tty-cursor'
require 'tty/spinner/version'
require 'tty/spinner/formats'

module TTY
  # Used for creating terminal spinner
  #
  # @api public
  class Spinner
    include Formats

    # @raised when attempting to join dead thread
    NotSpinningError = Class.new(StandardError)

    ECMA_ESC = "\x1b".freeze
    ECMA_CSI = "\x1b[".freeze
    ECMA_CHA = 'G'.freeze
    ECMA_CLR = 'K'.freeze

    DEC_RST = 'l'.freeze
    DEC_SET = 'h'.freeze
    DEC_TCEM = '?25'.freeze

    MATCHER = /:spinner/
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

    # Tokens for the message
    #
    # @return [Hash[Symbol, Object]]
    #   the current tokens
    #
    # @api public
    attr_reader :tokens

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
      @tokens  = {}

      @format      = options.fetch(:format) { :classic }
      @output      = options.fetch(:output) { $stderr }
      @hide_cursor = options.fetch(:hide_cursor) { false }
      @frames      = options.fetch(:frames) do
                       fetch_format(@format.to_sym, :frames)
                     end
      @clear       = options.fetch(:clear) { false }
      @success_mark= options.fetch(:success_mark) { TICK }
      @error_mark  = options.fetch(:error_mark) { CROSS }
      @interval    = options.fetch(:interval) do
                       fetch_format(@format.to_sym, :interval)
                     end

      @callbacks   = Hash.new { |h, k| h[k] = [] }
      @length      = @frames.length
      @current     = 0
      @done        = false
      @state       = :stopped
      @thread      = nil
      @multispinner= nil
      @index       = nil
      @succeeded   = false
      @first_run  = true
    end

    def add_multispinner(multispinner, index)
      @multispinner = multispinner
      @index = index
    end

    def succeeded?
      done? && @succeeded
    end

    def errored?
      done? && !@succeeded
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

    def done?
      @done
    end

    # Register callback
    #
    # @api public
    def on(name, &block)
      @callbacks[name] << block
      self
    end

    # Start timer and unlock spinner
    #
    # @api public
    def start
      @started_at = Time.now
      @done = false
      reset
    end

    SPINNER_START_LOCK = Mutex.new
    # Start automatic spinning animation
    #
    # @api public
    def auto_spin
      # TODO: this should probably be the same lock (will need to be a Monitor
      #   rather than a Mutex) as execute_on_line, so that a spinner starts
      #   completely before another tries to redraw itself. Also, spin needs to
      #   run once before a spinner is fully started, so we should probably run
      #   it once, and then start the Thread.
      SPINNER_START_LOCK.synchronize do
        start
        sleep_time = 1.0 / @interval
        @thread = Thread.new do
          while @started_at
            spin
            sleep(sleep_time)
          end
        end
      end
    end

    # Run spinner while executing job
    #
    # @param [String] stop_message
    #   the message displayed when block is finished
    #
    # @yield automatically animate and finish spinner
    #
    # @example
    #   spinner.run('Migrated DB') { ... }
    #
    # @api public
    def run(stop_message = '', &block)
      auto_spin

      @work = Thread.new(&block)
      @work.join
    ensure
      stop(stop_message)
    end

    # Duration of the spinning animation
    #
    # @return [Numeric]
    #
    # @api public
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
      unless @thread
        raise(NotSpinningError, 'Cannot join spinner that is not running')
      end

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
      data = replace_tokens(data)
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
      return if @done

      if @hide_cursor
        write(ECMA_CSI + DEC_TCEM + DEC_SET, false)
      end
      return clear_line if @clear

      data = message.gsub(MATCHER, next_char)
      data = replace_tokens(data)
      if !stop_message.empty?
        data << ' ' + stop_message
      end

      write(data, true)
      write("\n", false) unless @clear
    ensure
      @state      = :stopped
      @done       = true
      @started_at = nil
      emit(:done)
      kill
    end

    # Retrieve next character
    #
    # @return [String]
    #
    # @api private
    def next_char
      if success?
        @success_mark
      elsif error?
        @error_mark
      else
        @frames[@current - 1]
      end
    end

    # Finish spinning and set state to :success
    #
    # @api public
    def success(stop_message = '')
      @state = :success
      @succeeded = true
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
      write(ECMA_CSI + '0m' + ECMA_CSI + '1000D' + ECMA_CSI + ECMA_CLR)
    end

    # Update string formatting tokens
    #
    # @param [Hash[Symbol]] tokens
    #   the tokens used in formatting string
    #
    # @api public
    def update(tokens)
      clear_line if spinning?
      @tokens.merge!(tokens)
    end

    # Reset the spinner to initial frame
    #
    # @api public
    def reset
      @current = 0
      @first_run = true
    end

    private

    LOCK = Mutex.new

    def execute_on_line
      if @multispinner
        LOCK.synchronize do
          lines_up = @multispinner.count_line_offset(@index)

          if @first_run
            yield if block_given?
            output.print "\n"
            @first_run = false
          else
            output.print TTY::Cursor.save
            output.print TTY::Cursor.up lines_up
            yield if block_given?
            output.print TTY::Cursor.restore
          end
        end
      else
        yield if block_given?
      end
    end

    # Write data out to output
    #
    # @return [nil]
    #
    # @api private
    def write(data, clear_first = false)
      execute_on_line do
        output.print(ECMA_CSI + '1' + ECMA_CHA) if clear_first
        output.print(data)
        output.flush
      end
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
    def fetch_format(token, property)
      if FORMATS.key?(token)
        FORMATS[token][property]
      else
        raise ArgumentError, "Unknown format token `:#{token}`"
      end
    end

    # Replace any token inside string
    #
    # @param [String] string
    #   the string containing tokens
    #
    # @return [String]
    #
    # @api private
    def replace_tokens(string)
      data = string.dup
      @tokens.each do |name, val|
        data.gsub!(/\:#{name}/, val)
      end
      data
    end
  end # Spinner
end # TTY
