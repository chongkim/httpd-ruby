require "timeout"
require "socket"

class HTTPServer
  class Request
    attr_reader :http_method, :uri, :version
    def initialize(client)
      request_str = client.readline
      http_method_str, @uri, @version = request_str.split(/ +/)
      @http_method = http_method_str.downcase.to_sym
    end
    def filename
      return "/index.html" if @uri == "/"
      @uri
    end
  end

  class Response
    attr_reader :content
    def initialize(request)
      @request = request
      @content = ""
    end
    def status
      "#{@request.version} 200 OK"
    end
    def <<(content)
      @content << content
    end
  end

  def initialize(port)
    @port = port
  end
  def start
    @server = Socket.new(:INET, :STREAM, 0)
    @server.setsockopt(:SOCKET, :REUSEADDR, true)
    @server.bind(Addrinfo.tcp("127.0.0.1", @port))
    @server.listen(5)
    calling_thread = Thread.current
    Thread.new {
      begin
        if !@server.closed?
          client, client_addr_in = @server.accept
          request = Request.new(client)
          response = Response.new(request)
          handle_request(request, response)
          client.write("#{response.status}\r\n\r\n")
          client.write(response.content)
          client.close
        end
      rescue Errno::EBADF
        # the socket was already closed when server was accepting
        # connections.  this means we're shutting down
        # -- do nothing
      rescue Exception => e
        # raise the exception in the calling thread so we can
        # see the error
        calling_thread.raise(e)
      end
    }
    self
  end
  def close
    @server.close
  end
  def handle_request(request, response)
    File.open("public#{request.filename}") do |f|
      response << f.read
    end
  end
end
