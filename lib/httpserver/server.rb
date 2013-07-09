require "socket"
require "timeout"
require "httpserver/request"
require "httpserver/response"
require "httpserver/handler"

class HTTPServer
  def initialize(port)
    @port = port
  end
  def start_loop
    create_server
    accept_loop
  end

  def close
    @server.close
  end

  def create_server
    @server = Socket.new(:INET, :STREAM, 0)
    @server.setsockopt(:SOCKET, :REUSEADDR, true)
    @server.bind(Addrinfo.tcp("127.0.0.1", @port))
    @server.listen(5)
  end
  def accept_loop
    while !@server.closed?
      begin
        client, client_addr_in = @server.accept
        request = Request.new(client)
        response = Response.new(request)
        handle_request(request, response)
        client.write("#{response.status}\r\n\r\n#{response.content}")
        client.close
      end
    end
  rescue Errno::EBADF
    # the socket was already closed while server was accepting
    # connections.  this means we're shutting down
    # -- do nothing
  end
end
