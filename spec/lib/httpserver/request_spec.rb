require "spec_helper"

describe HTTPServer::Request do
  context "#new" do
    it "should take a client" do
      client = double
      client.stub(:readline).and_return("GET / HTTP/1.0\r\n", "\r\n", nil)
      request = HTTPServer::Request.new(client, double.as_null_object)
      request.http_method.should == :get
      request.uri.should == "/"
      request.version.should == "HTTP/1.0"
    end
  end

  context "#filename" do
    it "should be the same as uri" do
      client = double
      client.stub(:readline).and_return("GET /index.html HTTP/1.0\r\n", nil)
      request = HTTPServer::Request.new(client, double.as_null_object)
      request.filename.should == "/index.html"
    end
  end

  context "#body" do
    it "should store the content from the client" do
      client = double
      client.stub(:readline).and_return(
        "POST /foo HTTP/1.0\r\n",
        "Content-Length: 4\r\n",
        "\r\n", nil)
      client.stub(:read => "abc\n")
      request = HTTPServer::Request.new(client, double.as_null_object)
      request.body.should == "abc\n"
    end
  end
end

