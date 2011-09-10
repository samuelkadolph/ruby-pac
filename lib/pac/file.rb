require "uri"

module PAC
  require "pac/functions"

  class File
    attr_reader :source, :context

    def initialize(source)
      @source = source.dup.freeze
      @context = PAC.runtime.compile(@source)
      @context.include Functions
    end

    def find(url)
      uri = URI.parse(url)
      raise ArgumentError, "url is missing host" unless uri.host
      context.call("FindProxyForURL", url, uri.host)
    end
  end
end
