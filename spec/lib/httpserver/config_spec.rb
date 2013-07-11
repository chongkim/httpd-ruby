require "spec_helper"

describe HTTPServer::Config do
  context "#redirect" do
    it "should store the redirect config" do
      server = HTTPServer.new(port)
      server.config.redirect["/redirect"] = "/"
      server.config.redirect["/redirect"].should == "/"
    end
  end
  context "#deny?" do
    it "should check if the URI is denied" do
      server = HTTPServer.new(port)
      server.config.deny[:post] << "/foo"
      server.config.deny?(:post, "/foo").should == true
    end
  end
end
