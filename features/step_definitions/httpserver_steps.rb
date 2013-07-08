require "httpserver"

Given(/^an HTTP server on port (\d+)$/) do |port|
  @server = HTTPServer.new(port).start
end

Given(/^a file "(.*?)" with$/) do |filename, string|
  File.open(filename, "w") do |f|
    f.write(string)
  end
end

When(/^I fetch "(.*?)"$/) do |url|
  _, protocol, host, port, uri = %r{(.*)://(.*):(\d+)(.*)}.match(url).to_a
  client = TCPSocket.new(host, port)
  client.write("GET / HTTP/1.0\r\n\r\n")
  @content = client.read
  client.close
end

Then(/^I should see "(.*?)"$/) do |string|
  @content.should include(string)
end
