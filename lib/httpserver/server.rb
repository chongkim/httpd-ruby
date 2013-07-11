require "socket"
require "timeout"
require "httpserver/request"
require "httpserver/response"
require "httpserver/config"
require "httpserver/handler"

class HTTPServer
  attr_accessor :config
  attr_reader :logger, :port
  def initialize(port)
    @port = port
    @logger = Logger.new
    @config = Config.new
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
    logger.debug(:server, "server listening on port #{port}")
  end
  def accept_loop
    logger.debug(:server, "accepting connections")
    while !@server.closed?
      begin
        client, client_addr_in = @server.accept
        logger.debug(:server, "got connected")
        request = Request.new(client,logger)
        response = Response.new(request)
        handle_request(request, response)
        send_response(response)
        client.close
      end
    end
  rescue Errno::EBADF
    # the socket was already closed while server was accepting
    # connections.  this means we're shutting down
    # -- do nothing
  end
  def send_response(response)
    client = response.request.client
    client.write("#{response.status}\r\n")
    response.headers.each do |key,value|
      client.write("#{key}: #{value}\r\n")
    end
    client.write("\r\n")
    client.write("#{response.body}")
  end
end
