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
      @socket.send "USER Lurker durr derp :no wai \n", 0
      @socket.send "NICK #{@name} \n", 0
      @socket.send "JOIN ##{@channel} \n", 0
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
      @socket.send "PONG #{line[:type]}", 0
    end

    def send(msg)
      @socket.send(msg)
    end
  end
end
