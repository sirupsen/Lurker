#!/usr/bin/ruby
require 'Lurker'
fake = Lurker.new("testlogbot", "irc.freenode.net", 6667, "TestLogBot")
fake.connect
fake.start
