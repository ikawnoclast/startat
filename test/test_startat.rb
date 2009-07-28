require "test/unit"
require "date"
require "startat"

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

# Unit test suite
class TestStartat < Test::Unit::TestCase
  def test_initialization1
    action = lambda { val = true }
    test = nil
    start = DateTime.now
    assert_nothing_raised(ArgumentError) {
      test = StartAt.new(start, &action)
    }
    assert_not_nil test
    assert_equal(start, test.start_datetime)
  end
  
  def test_initialization2
    test = nil
    start = DateTime.now
    assert_nothing_raised(ArgumentError) {
      test = StartAt.new(start) { val = true }
    }
    assert_not_nil test
    assert_same(start, test.start_datetime)
  end
  
  def test_initialization3
    test = StartAt
    assert_raise(ArgumentError) {
      test.new(DateTime.now)
    }
  end
  
  def test_initialization4
    assert_raise(ArgumentError) {
      test = StartAt.new(Time.now) { val = true }
    }
  end
  
  def test_initialization5
    assert_raise(ArgumentError) {
      test = StartAt.new("This should fail") { val = true }
    }
  end
  
  def test_start1
    action = lambda { val = true }
    test = StartAt.new((Time.now + 5).to_datetime, &action)
    test.start
    assert_equal("sleep", test.status)
    test.cancel
  end
  
  def test_stop1
    action = lambda { val = true }
    test = StartAt.new((Time.now + 5).to_datetime, &action)
    test.start
    test.cancel
    assert(test.status)
  end
  
  def test_stop2
    action = lambda { val = true }
    test = StartAt.new((Time.now + 5).to_datetime, &action)
    test.start
    test.kill
    assert(test.status)
  end
  
  def comparison1
    test1 = StartAt
    test2 = StartAt
    test1.new((Time.now + 2).to_datetime) { val1 = true }
    test2.new((Time.now + 3).to_datetime) { val2 = true }
    assert_not_equal(test1, test2)
  end
  
  def comparison2
    date_time = (Time.now + 2).to_datetime
    test1 = StartAt.new(date_time) { val1 = true }
    test2 = StartAt.new(date_time) { val2 = true }
    assert_equal(test1, test2)
  end
  
  def comparison3
    test1 = StartAt
    test2 = StartAt
    test1.new((Time.now + 2).to_datetime) { val1 = true }
    test2.new((Time.now + 3).to_datetime) { val2 = true }
    assert_operator(test1, :<, test2)
  end
  
  def test_invalid_time1
    action = lambda { val = true }
    test = StartAt.new((Time.now - 2).to_datetime, &action)
    test.start
    assert(!test.status)
  end
  
  def test_timing1
    val = true
    test = StartAt.new((Time.now + 2).to_datetime) { val = false }
    test.start
    assert(val)
    sleep 1
    assert(val)
    sleep 2
    assert(!val)
  end
  
  def test_get_time_before1
    time_now = Time.now
    datetime_now = time_now.to_datetime
    lead_times = [ 5, 30, 120, 3600, 43200, 86400, 604800 ]
    lead_times.each { | lead_time | 
      time_before = StartAt.get_time_before(datetime_now, lead_time)
      assert_equal((time_now - lead_time).to_datetime, time_before)
    }
  end

  def test_get_time_after1
    time_now = Time.now
    datetime_now = time_now.to_datetime
    lead_times = [ 5, 30, 120, 3600, 43200, 86400, 604800 ]
    lead_times.each { | lead_time | 
      time_before = StartAt.get_time_after(datetime_now, lead_time)
      assert_equal((time_now + lead_time).to_datetime, time_before)
    }
  end
end
