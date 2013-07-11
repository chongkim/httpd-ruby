require "timeout"
require "httpserver/logger"

class HTTPServer
  class Request
    attr_reader :http_method, :uri, :version, :body, :client
    def initialize(client,logger)
      @client = client
      @headers = {}
      request_str = timeout(5) { client.readline }
      logger.debug(:request, request_str)
      http_method_str, @uri, @version = request_str.split(/\s+/)
      @http_method = http_method_str.downcase.to_sym
      @uri = "/#{@uri}" if !@uri.start_with?("/")
      while line = timeout(5) { client.readline }
        logger.debug(:request, line)
        break if line == "\r\n" || line == "\n" || line == ""
        line.chomp!
        line.chomp!("\r")
        key, value = line.split(": ")
        value = value.to_i if key == "Content-Length"
        @headers[key] = value
      end
      if content_length
        @body = timeout(5) { client.read(content_length) }
        logger.debug(:request, @body)
      end
    # rescue Exception => e
    #   @http_method = nil
    end
    def content_length
      @headers["Content-Length"]
    end
    def filename
      @uri
    end
    def [](key)
      @headers[key]
    end
  end
end
