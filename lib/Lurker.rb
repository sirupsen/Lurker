%w{
  rubygems
  socket
  mongo
  time
}.each {|gem| require gem}

%w{
  extensions
  plugins.rb
  plugins/logger
  irc
  worker
}.each {|lib| require "lurker/#{lib}"}
