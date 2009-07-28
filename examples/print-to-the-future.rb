#! /usr/bin/env ruby -w

#
# print-to-the-future.rb -- Schedules and prints messages in the future.
#
# Copyright (c) 2009 Keith A. Watson <ikawnoclast@interocitry.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'date'
require 'startat'

# The following is borrowed from the _Ruby Cookbook_, Lucas Carlson & Leonard 
# Richardson, O'Reilly Press, page 111.
# Time.to_datetime exists -- it's private though.
class Time
  def to_datetime
    seconds = sec + Rational(usec, 10**6)
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

Time_format = "%b %e %H:%M:%S"

puts "Start time: #{DateTime.now.strftime(Time_format)}"

schedule = {
  (Time.now +  5).to_datetime     => "5 seconds later",
  (Time.now +  10).to_datetime    => "10 seconds later",
  (Time.now +  33).to_datetime    => "33 seconds later",
  (Time.now + 1 * 60).to_datetime => "1 minute later",
  (Time.now + 2 * 60).to_datetime => "2 minutes later and done."
}

scheduled_events = Array.new

schedule.each { | event_time, msg |
  action = lambda {
    puts "#{DateTime.now.strftime(Time_format)} #{msg}"
  }

  # create and start the scheduler for the future event
  future_event = StartAt.new(event_time, &action)
  future_event.start

  # store the event
  scheduled_events.push(future_event)
}

# wait out the longest thread
sleep 2 * 60 + 1
