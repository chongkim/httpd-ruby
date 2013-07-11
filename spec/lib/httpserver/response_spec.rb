require "spec_helper"

describe HTTPServer::Response do
  context "#new" do
    it "should take a request" do
      request = double
      response = HTTPServer::Response.new(request)
    end
  end

  context "#body" do
    it "should store the body" do
      request = double
      response = HTTPServer::Response.new(request)
      response << "foo"
      response << " bar"
      response.body.should == "foo bar"
    end
  end

  context "#code" do
    it "should store the code" do
      request = double(:version => "HTTP/1.0")
      response = HTTPServer::Response.new(request)
      response.code = 404
      response.code.should == 404
      response.status.should include("404 Not Found")
    end
  end

end

