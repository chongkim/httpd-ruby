require "httpserver"
require "httparty"

def port
  5001
end

def start_http_server(port)
  server = HTTPServer.new(port)
  server.create_server
  calling_thread = Thread.current
  Thread.new {
    begin
      server.accept_loop
    rescue Exception => e
      calling_thread.raise(e)
    end
  }
  server
end
