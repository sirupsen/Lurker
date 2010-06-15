module Lurker
  module Plugins
    class Logger
      def self.run(line, worker)
        self.new(line, worker).log
      end

      def initialize(line, worker)
        @line, @worker = line, worker
      end

      def log
        db = Mongo::Connection.new("localhost").db("lurker")
        collection = db.collection(collection_name)

        document = {
          "username"  => @line[:username],
          "user"      => @line[:user],
          "type"      => @line[:type],
          "message"   => @line[:message],
          "timestamp" => Time.now.to_i
        }
        collection.insert(document)
      end

      def collection_name
        # Appropriate collection name:
        #   host__channel
        # E.g.
        #   irc_freenode_net__lurker
        "#{@worker.server.gsub(".", "_")}__#{@worker.channel.gsub(".", "_")}"
      end
    end
  end
end
