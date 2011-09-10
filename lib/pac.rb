require "rubygems"

module PAC
  require "pac/version"
  require "pac/file"
  require "pac/runtimes"

  class Error < StandardError
  end
  class RuntimeError < Error
  end
  class ProgramError < Error
  end
  class RuntimeUnavailable < RuntimeError
  end

  class << self
    attr_reader :runtime

    def runtime=(runtime)
      raise RuntimeUnavailable, "#{runtime.name} is unavailable on this system" unless runtime.available?
      @runtime = runtime
    end

    def load(url, options = {})
      require "open-uri"
      File.new(open(url, { :proxy => false }.merge(options)).read)
    end

    def read(file)
      File.new(::File.read(file))
    end

    def source(source)
      File.new(source)
    end
  end

  self.runtime = Runtimes.autodetect
end
