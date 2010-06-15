module Lurker
  class Worker
    def initialize(channel, server, port, name)
      #Make variables we will use.
      @channel, @server, @port, @name = channel, server, port, name
    end

    def connect
      # Connect to IRC
      @irc = Irc.new(@channel, @server, @port, @name)
      # Send Ident, name, etc.
      @irc.connect
    end

    def start
      @work = true

      while @work
        line = @irc.gets #Receive

        case line[:type]
          when "PRIVMSG"
            log(line)
          when "PING"
            @irc.pong
        end
      end
    end

    def stop
      @work = nil
    end

    private
      # TODO make this a plugin
      def log(line)
        db = Mongo::Connection.new("localhost").db("lurker")
        collection = db.collection(collection_name)

        document = {
          "username"  => line[:username],
          "user"      => line[:user],
          "type"      => line[:type],
          "message"   => line[:message],
          "timestamp" => Time.now.to_i
        }
        collection.insert(document)
      end

      def collection_name
        # Appropriate collection name:
        #   host__channel
        # E.g.
        #   irc_freenode_net__lurker
        "#{@server.gsub(".", "_")}__#{@channel.gsub(".", "_")}"
      end

      def debug(line)
        time = Time.now
        puts "(#{time.hour}:#{time.min}:#{time.sec}) #{line[:username]}: #{line[:message]}"       
      end
  end
end
