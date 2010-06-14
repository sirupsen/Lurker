#!/usr/bin/ruby
require 'Lurker'

work = true

p "Lurker Interface 0.1"
p "Well, sorta, actually it just makes one and lets you interact."

while work == true
  i = gets(">")
  i = i.split(" ")
  case i[0]
    when "new"
      inter = Lurker.new(i[1], i[2], i[3], i[4])
    when "connect"
      inter.connect unless inter.nil?
    when "start"
      inter.start unless inter.nil?
    when "stop"
      inter.stop unless inter.nil?
    else
      p "What?"
  end
end
