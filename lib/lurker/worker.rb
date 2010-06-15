module Lurker
  class Worker
    include Plugins
    attr_reader :server, :channel, :port, :name, :irc

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
            run_plugins(line, self)
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
      def debug(line)
        time = Time.now
        puts "(#{time.hour}:#{time.min}:#{time.sec}) #{line[:username]}: #{line[:message]}"       
      end
  end
end
