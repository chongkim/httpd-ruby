require "httpserver"

Before do |scenario|
  @local = {}
end

After do |scenario|
  if !@local[:server].nil?
    @local[:server].close
  end
end

Given(/^an HTTP server on port (\d+)$/) do |port|
  @local[:server] = HTTPServer.new(port)
  @local[:server].create_server
  calling_thread = Thread.current
  Thread.new {
    begin
      @local[:server].accept_loop
    rescue Exception => e
      calling_thread.raise(e)
    end
  }
end

Given(/^a file "(.*?)" with$/) do |filename, string|
  File.open(filename, "w") do |f|
    f.write(string)
  end
end

When(/^I fetch "(.*?)"$/) do |url|
  _, protocol, host, port, uri = %r{(.*)://(.*):(\d+)(.*)}.match(url).to_a
  client = TCPSocket.new(host, port)
  client.write("GET #{uri} HTTP/1.0\r\n\r\n")
  @local[:header], @local[:content] = timeout(0.3) { client.read.split(/\r\n\r\n|\n\n/) }
  client.close
end

Then(/^I should see "(.*?)"$/) do |string|
  @local[:content].should include(string)
end

Then(/^the return code is (\d+)$/) do |code|
  @local[:header].split(/\s+/)[1].should == code.to_s
end
