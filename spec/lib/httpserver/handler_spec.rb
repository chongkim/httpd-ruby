require "spec_helper"

def test_handle_get(uri)
  server = start_http_server(port)
  client = double(:readline => "GET #{uri} HTTP/1.0\r\n\r\n")
  request = HTTPServer::Request.new(client)
  response = HTTPServer::Response.new(request)
  server.handle_request(request, response)
  server.close
  response
end

describe HTTPServer do
  context "#handle_request" do
    it "should handle a page request" do
      response = test_handle_get("/index.html")
      response.code.should == 200
      response.content.should include("hello")
    end
    it "should handle a directory request" do
      response = test_handle_get("/")
      response.code.should == 200
      response.content.should include("index.html")
    end
    it "should handle a non-existant file" do
      response = test_handle_get("/does-not-exist")
      response.code.should == 404
      response.content.should include("File not found")
    end
  end
end
