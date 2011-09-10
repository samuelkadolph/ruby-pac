module PAC
  module Runtimes
    require "pac/runtimes/rubyracer"
    require "pac/runtimes/rubyrhino"
    require "pac/runtimes/johnson"
    require "pac/runtimes/mustang"

    RubyRacer = RubyRacerRuntime.new
    RubyRhino = RubyRhinoRuntime.new
    Johnson = JohnsonRuntime.new
    Mustang = MustangRuntime.new

    class << self
      def autodetect
        from_environment || best_available || raise(RuntimeUnavailable, "Could not find a JavaScript runtime. See https://github.com/samuelkadolph/ruby-pac for a list of runtimes.")
      end

      def from_environment
        if name = ENV["JS_RUNTIME"]
          if runtime = const_get(name)
            if runtime.available?
              runtime if runtime.available?
            else
              raise RuntimeUnavailable, "#{runtime.name} runtime is not available on this system"
            end
          elsif !name.empty?
            raise RuntimeUnavailable, "#{name} runtime is not defined"
          end
        end
      end

      def best_available
        runtimes.find(&:available?)
      end

      def runtimes
        @runtimes ||= [RubyRacer, RubyRhino, Johnson, Mustang]
      end
    end
  end

  def self.runtimes
    Runtimes.runtimes
  end
end
