require "spec_helper"

describe HTTPServer do
  context "#public_dir" do
    it "should use the supplied public_dir" do
      server = start_http_server(port)
      server.public_dir = "./features/support"
      client_send("/env.rb").should include("LOAD_PATH")
      server.close
    end
  end
end
