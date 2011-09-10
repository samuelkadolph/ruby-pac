module PAC
  module Runtimes
    class RubyRhinoRuntime
      class Context
        def initialize(source = "")
          source = source.encode("UTF-8") if source.respond_to?(:encode)

          @rhino_context = Rhino::Context.new
          fix_memory_limit! @rhino_context
          @rhino_context.eval(source)
        end

        def include(mod)
          (mod.methods - Module.methods).each do |name|
            @rhino_context[name] = mod.method(name)
          end
        end

        def call(properties, *args)
          unbox @rhino_context.eval(properties).call(*args)
        rescue ::Rhino::JavascriptError => e
          if e.message == "syntax error"
            raise RuntimeError, e.message
          else
            raise ProgramError, e.message
          end
        end

        def unbox(value)
          case value = ::Rhino::To.ruby(value)
          when ::Rhino::NativeFunction
            nil
          when ::Rhino::NativeObject
            value.inject({}) do |vs, (k, v)|
              case v
              when ::Rhino::NativeFunction, ::Rhino::J::Function
                nil
              else
                vs[k] = unbox(v)
              end
              vs
            end
          when Array
            value.map { |v| unbox(v) }
          else
            value
          end
        end

        private
          # Disables bytecode compiling which limits you to 64K scripts
          def fix_memory_limit!(context)
            if context.respond_to?(:optimization_level=)
              context.optimization_level = -1
            else
              context.instance_eval { @native.setOptimizationLevel(-1) }
            end
          end
      end

      def name
        "therubyrhino (Rhino)"
      end

      def compile(source)
        Context.new(source)
      end

      def available?
        require "rhino"
        true
      rescue LoadError
        false
      end
    end
  end
end
