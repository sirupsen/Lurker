require 'rubygems'
require 'socket'
require 'mongo'
require 'time'

class Lurker
  def initialize(channel, server, port, name)
    #Make variables we will use.
    @channel, @server, @port, @name = channel, server, port, name
  end

  def connect
    #Create socket, send ident, name and other stuff.
    #Connect to channel.
    @db = Mongo::Connection.new("localhost").db("lurker")
    raise "Cant connect to MongoDB, turn that on first, stupid." unless @db
    @coll = @db.collection("#{@server.gsub(".", "_")}__#{@channel.gsub(".", "_")}")
    @s = TCPSocket.open(@server, @port)
    raise "Cant connect to IRC server." unless @s
    @s.send "USER Lurker durr derp :no wai \n", 0
    @s.send "NICK #{@name} \n", 0
    @s.send "JOIN ##{@channel} \n", 0
  end

  def log
    @work = true

    while @work
      #Socket receive and store.
      #Respond to pings.
      line = @s.gets #Receive.
      p line  #For debug purposes.
      line = line.chomp.split(" ")

      if line[1] == "PRIVMSG"
        guy = line[0].split("!")[0]
        msg = line[3..-1].join(" ")
        p "#{guy} #{line[3..-1].join(" ")}" #For debug purposes.
        doc = {"name" => guy, "message" => msg, "date" => Time.now.to_i}
        @coll.insert(doc)
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
