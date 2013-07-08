require "httpserver"

describe HTTPServer::Request do
  context "#new" do
    it "should take a client" do
      client = double(:readline => "GET / HTTP/1.0")
      request = HTTPServer::Request.new(client)
      request.http_method.should == :get
      request.uri.should == "/"
      request.version.should == "HTTP/1.0"
    end
  end
  context "#filename" do
    it "should be the same as uri" do
      client = double(:readline => "GET /index.html HTTP/1.0")
      request = HTTPServer::Request.new(client)
      request.filename.should == "/index.html"
    end
    it "should default to /index.html" do
      client = double(:readline => "GET / HTTP/1.0")
      request = HTTPServer::Request.new(client)
      request.filename.should == "/index.html"
    end
  end
end

describe HTTPServer::Response do
  context "#new" do
    it "should take a request" do
      request = double
      response = HTTPServer::Response.new(request)
    end
  end
  context "#content" do
    it "should store the content" do
      request = double
      response = HTTPServer::Response.new(request)
      response << "foo"
      response << " bar"
      response.content.should == "foo bar"
    end
  end
end


describe HTTPServer do
  let(:port) { 5000 }
  context "#new" do
    it "should take a port" do
      HTTPServer.new(port)
    end
  end
  context "#start" do
    it "should start the server and return" do
      server = Timeout.timeout(0.3) { HTTPServer.new(port).start }
      socket = TCPSocket.new("localhost", port)
      socket.write("GET / HTTP/1.0\r\n\r\n")
      socket.read
      socket.close
      server.close
    end
  end
  context "#handle_request" do
    it "should handle a page request" do
      server = HTTPServer.new(port).start
      client = double(:readline => "GET / HTTP/1.0")
      request = HTTPServer::Request.new(client)
      response = HTTPServer::Response.new(request)
      server.handle_request(request, response)
      server.close
    end
  end
end
