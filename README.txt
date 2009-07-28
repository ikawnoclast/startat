= startat

* http://startat.rubyforge.org/

== DESCRIPTION:

StartAt is a simple class for future code execution.  It is designed
to execute a block of code at a specific point in time in the future.

StartAt works by spawning a new thread, determining how long it must wait (in 
seconds) until the future date and time is reached, calling sleep with the
exact number of seconds to wait, and then executing the code block.

StartAt was derived from a script written to post schedule information to
Twitter for a symposium. The schedule robot posted event details exactly
five minutes in advance of the event.

== FEATURES/PROBLEMS:

Issues:
* This is an alpha release. The developer is interested in feedback on the API.
* StartAt currently operates with whole seconds, not microseconds.
* A running (waiting) StartAt object can be interrupted early with SIGALARM.
* Thread safety issues have not been examined or addressed yet.

== SYNOPSIS:

  require 'date'
  require 'startat'

  future_time = DateTime.parse("2010-03-24 03:34:45 PM EDT")
  action = lambda { print "The time is now!" }
  future_event = StartAt.new(future_time, &action)
  future_event.start
  future_event.join

== REQUIREMENTS:

* date

== INSTALL:

* sudo gem install startat

== LICENSE:

(The MIT License)

Copyright (c) 2009 Keith A. Watson <ikawnoclast@interocitry.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
