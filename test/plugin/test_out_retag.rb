require 'helper'

class RetagOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    tag hoge
  ]
  CONFIG2 = %[
    remove_prefix foo
  ]
  CONFIG3 = %[
    remove_prefix foo
    add_prefix head
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::RetagOutput, tag).configure(conf)
  end

  def test_configure
    assert_raise(Fluent::ConfigError) {
      create_driver ('')
    }
    assert_raise(Fluent::ConfigError) {
      create_driver %[
        tag a
        remove_prefix b
      ]
    }
    assert_raise(Fluent::ConfigError) {
      create_driver %[
        tag a
        add_prefix c
      ]
    }
    d1 = create_driver %[
      tag a
    ]
    d1.instance.inspect
    assert_equal 'a', d1.instance.tag
    d2 = create_driver %[
      remove_prefix b
      add_prefix c
    ]
    d2.instance.inspect
    assert_equal 'b', d2.instance.remove_prefix
    assert_equal 'c', d2.instance.add_prefix
  end

  def test_emit
    d = create_driver(CONFIG, 'foo.bar')
    time = Time.parse('2011-03-11 14:46:01').to_i
    d.run do
      d.emit({'a' => 'b'})
      d.emit({'c' => 'd'})
    end
    emits = d.emits
    assert_equal 2, emits.length
    p emits[0]
    assert_equal 'hoge', emits[0][0]
    assert_equal 'b', emits[0][2]['a']
  end

  def test_emit2
    d = create_driver(CONFIG2, 'foo.bar')
    time = Time.parse('2011-03-11 14:46:01').to_i
    d.run do
      d.emit({'a' => 'b'})
      d.emit({'c' => 'd'})
    end
    emits = d.emits
    assert_equal 2, emits.length
    p emits[0]
    assert_equal 'bar', emits[0][0]
    assert_equal 'b', emits[0][2]['a']
  end

  def test_emit3
    d = create_driver(CONFIG3, 'foo.bar')
    time = Time.parse('2011-03-11 14:46:01').to_i
    d.run do
      d.emit({'a' => 'b'})
      d.emit({'c' => 'd'})
    end
    emits = d.emits
    assert_equal 2, emits.length
    p emits[0]
    assert_equal 'head.bar', emits[0][0]
    assert_equal 'b', emits[0][2]['a']
  end

end

