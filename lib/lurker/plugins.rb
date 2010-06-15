module Lurker
  module Plugins
    # @TODO Save and load this stuff from a YAML file
    def plugins
      @plugins ||= {
        :Logger => true,
        :KittenCommand => true,
      }
    end

    def run_plugins(line, worker)
      plugins.each do |plugin, enabled|
        Plugins.const_get(plugin).run(line, worker) if enabled
      end
    end
  end
end
