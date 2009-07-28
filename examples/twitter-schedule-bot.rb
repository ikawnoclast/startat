#!/opt/local/bin/ruby -w 

#
# twitter-schedule-bot.rb -- A code example for using StartAt for posting
# a schedule of events for an event to Twitter.
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

#
# NOTE: This is an updated version of the code CERIAS used to post the
# schedule of events for the 20009 CERIAS Information Security Symposium.
# This code is missing the Twitter account details (username and password)
# and the events have already elapsed. This is only an example, but is 
# easily updated for your own events.
#

require 'rubygems'
require 'twitter'
require 'date'
require 'startat'

# message added to the beginning and end of the post
header="CERIAS Symposium Schedule:"
footer="#cerias"

# amount of time before the actual event to post info (in seconds)
leadTime = 5 * 60;

# Twitter account object creation
postService = Twitter::Base.new('myTwitterAccount', 'myTwitterPassword')

# schedule array containing event times and messages
schedule = {
	DateTime.parse('2009-03-24 09:30:00 AM EDT') \
	  => "Registration and Coffee in LWSN Commons",
	DateTime.parse('2009-03-24 10:30:00 AM EDT') \
	  => "Welcome in LWSN 1142",
	DateTime.parse('2009-03-24 10:35:00 AM EDT') \
	  => "Panel #1: Transitive Security & Standards Adoption in LWSN 1142",
	DateTime.parse('2009-03-24 12:15:00 PM EDT') \
	  => "Lunch in LWSN 1190",
	DateTime.parse('2009-03-24 01:45:00 PM EDT') \
	  => "Panel #2: Security in the Cloud in LWSN 1142",
	DateTime.parse('2009-03-24 03:30:00 PM EDT') \
	  => "Fireside Chat in LWSN 1142",
	DateTime.parse('2009-03-24 07:00:00 PM EDT') \
	  => "John Thompson, CEO Symantec in STEW Fowler Hall",
	DateTime.parse('2009-03-25 08:00:00 AM EDT') \
	  => "Registration and Coffee in LWSN Commons",
	DateTime.parse('2009-03-25 08:30:00 AM EDT') \
	  => "Morning Keynote Address: Dr. Ronald Ritchey in LWSN 1142",
	DateTime.parse('2009-03-25 09:45:00 AM EDT') \
	  => "Panel #3: Unsecured Economies in LWSN 1142",
	DateTime.parse('2009-03-25 11:15:00 AM EDT') \
	  => "Tech Talk Poster Preview in LWSN 1142",
	DateTime.parse('2009-03-25 12:30:00 PM EDT') \
	  => "Lunch and Awards in LWSN 1142",
	DateTime.parse('2009-03-25 02:00:00 PM EDT') \
	  => "Poster Session & CERIAS Anniversary Cake in LWSN Commons",
	DateTime.parse('2009-03-25 04:30:00 PM EDT') \
	  => "CERIAS Seminar in PFEN 241",
}

schedEvents = Array.new

schedule.keys.each { | event |
  # cacluate the time to post the message before the actual event
  postTime = StartAt.get_time_before(event, leadTime)
  # create the action of posting a message; pasted to the scheduler
  action = lambda {
    msg = "#{header} #{schedule[event]} starts at #{event.strftime("%l:%M")} #{footer}"
    puts "#{DateTime.now.strftime("%b %e %H:%M:%S")} Posting the following message: \"#{msg}\" (length=#{msg.length})"
    puts postService.post(msg).inspect
  }
  
  # create and start the scheduler for the future event
  futureEvent = StartAt.new(postTime, &action)
  futureEvent.start

  # store the event
  schedEvents.push(futureEvent)
}

# find the longest running thread and join it
longestEvent = StartAt.new(DateTime.now)
schedEvents.each { | eventPostTime | 
  if eventPostTime > longestEvent
    longestEvent = eventPostTime
  end
}
longestEvent.join

exit 0
