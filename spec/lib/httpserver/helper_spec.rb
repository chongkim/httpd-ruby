require "spec_helper"

describe HTTPServer do
  context "#public_dir" do
    it "should use the supplied public_dir" do
      server = start_http_server(port)
      server.public_dir = "./features/support"
      response = HTTParty.get("http://localhost:#{port}/env.rb")
      response.body.should include("LOAD_PATH")
      server.close
    end
  end
  context "#debug" do
    it "should store the debug output to a file" do
      server = start_http_server(port)
      server.logger.debug?.should == false
      server.debug = true
      server.logger.debug?.should == true
      server.close
    end
  end
end
