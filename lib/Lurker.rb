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
  plugins/kitten_command
  irc
  worker
}.each {|lib| require "lurker/#{lib}"}
