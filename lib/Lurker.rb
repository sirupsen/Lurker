require 'rubygems'
require 'socket'
require 'mongo'
require 'time'

class String
  def usernameify
    split("!")[0][1..-1]
  end
end

class Array
  def messageify
    join(" ")[1..-1].strip
  end
end

class Lurker
  PRIVMSG = "PRIVMSG"
  PING = "PING"

  def initialize(channel, server, port, name)
    #Make variables we will use.
    @channel, @server, @port, @name = channel, server, port, name
    @db = Mongo::Connection.new("localhost").db("lurker")
  end

  def connect
    #Create socket, send ident, name and other stuff.
    #Connect to channel.

    # Appropriate collection name:
    #   host__channel
    # E.g.
    #   irc_freenode_net__lurker
    @collection = @db.collection("#{@server.gsub(".", "_")}__#{@channel.gsub(".", "_")}")
    
    @socket = TCPSocket.open(@server, @port) # Connect to socket
    raise "Cant connect to IRC socket." unless @socket 

    # Set name, and join channel
    @socket.send "USER Lurker durr derp :no wai \n", 0
    @socket.send "NICK #{@name} \n", 0
    @socket.send "JOIN ##{@channel} \n", 0
  end

  def log
    @work = true

    while @work
      #Socket receive and store.
      #Respond to pings.
      line = @socket.gets #Receive.

      # Line looks something like this:
      #   User!host PRIVMSG #channel message
      # We split this into an Array.
      line = line.chomp.split(" ")

      if line[1] == PRIVMSG
        #puts "Connected to ##{@channel} on #{@server}" if line[0].usernameify == "frigg"

        # Converts:
        #   User!host
        # Into:
        #   User
        username = line[0].usernameify

        # We split the message as well, so we take
        # everything from index 3 -> end of array.
        #
        # Converts:
        #   :message
        # Into:
        #   message
        msg = line[3..-1].messageify

        # Time 
        time = Time.now

        #puts "(#{time.hour}:#{time.min}:#{time.sec}) #{username}: #{msg}"
        
        # Put into database
        document = {"name" => username, "message" => msg, "timestamp" => Time.now.to_i}
        @collection.insert(document)
      elsif line[0] == PING
        @socket.send "PONG #{line[1]}", 0
      end
    end
  end

  alias_method :start, :log

  def stop
    @work = nil
    #Socket send disconnect message, and disconnect.
  end
end
