require "spec_helper"

describe HTTPServer do

  context "#new" do
    it "should take a port" do
      HTTPServer.new(port)
    end
  end

  context "#start_loop" do

    it "should start the server and loop indefinitely accepting connections" do
      require "timeout"
      server = HTTPServer.new(port)
      expect { Timeout.timeout(0.5) { server.start_loop } }.to raise_error(Timeout::Error)
      server.close
    end

    it "handle more than one connection sequentially" do
      server = HTTPServer.new(port)
      Thread.new {
        begin
          server.start_loop
        rescue Exception => e
          puts "http server got an exception!"
          puts "-----------------------------"
          puts $!, $@
          calling_thread.raise(e)
        end
      }
      HTTParty.get("http://localhost:#{port}/index.html").body.should include("hello")
      HTTParty.get("http://localhost:#{port}/index.html").body.should include("hello")
      server.close
    end
  end

end
