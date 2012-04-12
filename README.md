# StartAt

StartAt is a simple Ruby class for future code execution.  It is designed
to execute a block of code at a specific point in time in the future.

StartAt works by spawning a new thread, determining how long it must wait (in 
seconds) until the future date and time is reached, calling sleep with the
exact number of seconds to wait, and then executing the code block in the 
thread context.

StartAt was derived from a script written to post schedule information to
Twitter for a symposium. The schedule robot posted event details exactly
five minutes in advance of the event.

## Issues

Issues:
* This is an alpha release. The developer is interested in feedback on the API.
* StartAt currently operates with whole seconds, not microseconds.
* A running (waiting) StartAt object can be interrupted early with SIGALARM.
* Thread safety issues have not been examined or addressed yet.

## Installation

Add this line to your application's Gemfile:

    gem 'startat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startat

## Usage

    require 'date'
    require 'startat'

    future_time = DateTime.parse("2010-03-24 03:34:45 PM EDT")
    action = lambda { print "The time is now!" }
    future_event = StartAt.new(future_time, &action)
    future_event.start
    future_event.join

## Requirements

* date

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
