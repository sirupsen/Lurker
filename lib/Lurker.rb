require 'socket'
class Lurker
  def initialize(channel, server, port, name)
    #Make variables we will use.
    @channel, @server, @port, @name = channel, server, port, name
  end

  def connect
    #Create socket, send ident, name and other stuff.
    #Connect to channel.
    @s = TCPSocket.open(@server, @port)
    @s.send "USER Lurker durr derp :no wai \n", 0
    @s.send "NICK #{@name} \n", 0
    @s.send "JOIN ##{@channel} \n", 0
  end

  def log
    @work = true

    while @work
      #Socket receive and store.
      #Respond to pings.
      line = @s.gets
      p line
      line = line.chomp.split(" ")

      if line[1] == "PRIVMSG"
        guy = line[0].split("!")[0]
        p "#{guy} #{line[3..-1].join(" ")}"
      elsif line[0] == "PING"
        @s.send "PONG #{line[1]}", 0
        p "PONG #{line[1]}"
      end
    end
  end

  alias_method :start, :log

  def stop
    @work = nil
    #Socket send disconnect message, and disconnect.
  end
end
