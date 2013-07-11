class HTTPServer
  class Config
    attr_accessor :redirect
    def initialize
      @redirect = {}
    end
  end
end
