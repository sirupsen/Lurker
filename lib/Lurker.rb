%w{
  rubygems
  socket
  mongo
  time
}.each {|gem| require gem}

%w{
  extensions
  irc
  worker
}.each {|lib| require "lurker/#{lib}"}
