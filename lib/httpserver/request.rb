class HTTPServer
  class Request
    attr_reader :http_method, :uri, :version
    def initialize(client)
      request_str = client.readline
      http_method_str, @uri, @version = request_str.split(/\s+/)
      @http_method = http_method_str.downcase.to_sym
    end
    def filename
      @uri
    end
  end
end
