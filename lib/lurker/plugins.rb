module Lurker
  module Plugins
    def plugins
      @plugins ||= {
        :Logger => true,
      }
    end

    def run_plugins(line, worker)
      plugins.each do |plugin, enabled|
        Plugins.const_get(plugin).run(line, worker) if enabled
      end
    end
  end
end
