require "spec_helper"

describe HTTPServer::Config do
  context "#redirect" do
    it "should store the redirect config" do
      server = HTTPServer.new(port)
      server.config.redirect["/redirect"] = "/"
      server.config.redirect["/redirect"].should == "/"
    end
  end
end
