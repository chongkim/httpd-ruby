class HTTPServer
  class Config
    attr_accessor :redirect, :deny
    def initialize
      @redirect = {}
      @deny = {
        :put => [],
        :get => [],
        :post => [],
        :delete => []
      }
    end
    def deny?(http_method, uri)
      @deny[http_method].include?(uri)
    end
  end
end
