require 'date'

#
# StartAt is class for executing code at a specific point in the future.
# The object is initialized with a #DateTime object with a point of time in the
# future and a code block to be executed. Calling #start will calculate the
# wait time (in seconds), initialize a #Thread that will then +sleep+ for the 
# appropriate amount of time, and then the code block will be executed.
#
# For example:
#
#       require 'date'
#       require 'startat'
#
#       bday = DateTime.parse("2009-08-20 08:30:00 AM EDT")
#       action = lambda { puts "Happy Birthday, Dad!" }
#       wait_for_it = StartAt.new(bday, &action)
#       wait_for_it.start
#       wait_for_it.join
#
#
# StartAt was originally written to post schedule information for a symposium to
# Twitter (see the examples directory). 
#
class StartAt
  VERSION = '0.1.0'
  include Comparable

  Seconds_per_day = 24 * 60 * 60 # :nodoc:

  attr_reader :start_datetime

  # Returns a new future action object that will execute the code block
  # at a point in the future as defined by #start_datetime.
  def initialize(start_datetime, &block)
    @thread_started = false
    if start_datetime.class == DateTime
      @start_datetime = start_datetime
    else
      raise ArgumentError.new("must have a DateTime object")
    end
    if block
      @action = block
    elsif block_given?
      @action = lambda { yield }
    else 
      raise ArgumentError.new("missing a block")
    end
  end

  # Compares the start #DateTime of the current future action with the 
  # start time of the #other future action.
  def <=> (other)
    @start_datetime <=> other.start_datetime
  end

  # Starts the future action thread by determining the time needed to wait
  # based on the start date and then executes the code block once the time 
  # has elapsed.
  def start
    if ! @thread_started
      @sleeper = Thread.new do
        wait = get_wait_time()
        # Check that the wait time is positive, otherwise the future
        # event time has already past. We skip it, since a warning
        # message was produced in wait_time.
        if wait > 0
          sleep wait
          @action.call
        end
      end
      @thread_started = true
    end
  end

  # Cancels a running future action object thread.
  def cancel
    if ! @thread_started
      @sleeper.exit
      @thread_started = false
    end
  end

  alias kill cancel

  # Returns the status of a future action object thread. See #Thread#status
  def status
    @sleeper.status
  end

  # Joins the current thread to the future action thread. See #Thread.join
  def join
    @sleeper.join
  end

  # Takes a future #DateTime object and returns a #DateTime object for the time
  # before as specified in +time_before+ in seconds.
  def self.get_time_before(future_datetime, time_before)
    future_datetime - Rational(time_before, Seconds_per_day)
  end

  # Takes a future #DateTime object and returns a #DateTime object for the time
  # after as specified in +time_before+ in seconds.
  def self.get_time_after(future_datetime, time_after)
    future_datetime + Rational(time_after, Seconds_per_day)
  end

  private

  def get_wait_time
    # 1. Find the difference between the time now and the future time.
    # 2. DateTime objects store time in whole seconds, so convert to the
    #     number of seconds in a day and return an interger.
    wait_time = (((@start_datetime - DateTime.now) * Seconds_per_day) + 1).to_i
    # send a warning message if the wait time is negative since the future
    #  time is no in the past.
    warn "Specified date and time of #{@start_datetime.to_s} has already elapsed" if wait_time <= 0
    return wait_time
  end

end