require "spec_helper"

describe HTTPServer::Request do
  context "#new" do
    it "should take a client" do
      client = double(:readline => "GET / HTTP/1.0\r\n")
      request = HTTPServer::Request.new(client)
      request.http_method.should == :get
      request.uri.should == "/"
      request.version.should == "HTTP/1.0"
    end
  end

  context "#filename" do
    it "should be the same as uri" do
      client = double(:readline => "GET /index.html HTTP/1.0\r\n")
      request = HTTPServer::Request.new(client)
      request.filename.should == "/index.html"
    end
  end
end

