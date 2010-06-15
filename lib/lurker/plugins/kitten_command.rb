module Lurker
  module Plugins
    class KittenCommand
      def self.run(line, worker)
        # Extremely annoying plugin which says meow each time it
        # sees a message!
        worker.irc.msg "Meow!"
      end
    end
  end
end
