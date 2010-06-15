module Lurker
  class Irc
    def initialize(channel, server, port, name)
      @channel, @server, @port, @name = channel, server, port, name
    end

    def connect
      @socket = TCPSocket.open(@server, @port) # Connect to socket
      set_defaults
    end

    def set_defaults
      # Set name, and join channel
      send "USER Lurker durr derp :no wai \n"
      send "NICK #{@name} \n"
      send "JOIN ##{@channel} \n"
    end

    def gets
      # Line string something like this:
      #   User!host PRIVMSG #channel message
      # We split this into an Array.
      line = @socket.gets.chomp.split(" ")

      {
        :user     => line[0],
        :username => line[0].usernameify,
        :type     => line[1],
        :channel  => line[2],
        :message  => line[3..-1].messageify
      }
    end

    def pong
      send "PONG #{line[:type]}"
    end

    def send(msg, n = 0)
      @socket.send(msg + "\n", n)
    end

    def msg(message)
      send "PRIVMSG ##{@channel} : #{message}\r"
    end
  end
end
