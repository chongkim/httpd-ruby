require "httpserver"
require "httparty"
require "cucumber/rspec/doubles"

Before do |scenario|
  @local = {}
end

After do |scenario|
  if !@local[:server].nil?
    @local[:server].close
  end
end

Given(/^port is (\d+)$/) do |port|
  @port = port
end

Given(/^an HTTP server$/) do
  @local[:server] = HTTPServer.new(@port)
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
  @local[:response] = HTTParty.get(url)
end

When(/^I crash the server$/) do
  client = TCPSocket.new("localhost", @port)
  client.write("CRASH / HTTP/1.0\r\n\r\n")
  header, body =  timeout(0.3) { client.read.split(/\r\n\r\n|\n\n/) }
  code = header.split(/\s+/)[1].to_i
  require "rspec/mocks/standalone"
  double
  @local[:response] = double(:body => body, :code => code)
  client.close
end

Then(/^I should see "(.*?)"$/) do |string|
  @local[:response].body.should include(string)
end

Then(/^the return code is (\d+)$/) do |code|
  @local[:response].code.should == code.to_i
end

Then(/^there is a link to "(.*?)"$/) do |link|
  @local[:response].body.should include("<a href=\"/#{link}\">#{link}</a>")
end

Given(/^I configure deny put "(.*?)"$/) do |uri|
  @local[:server].config.deny[:put] << uri
end

Given(/^I configure deny post "(.*?)"$/) do |uri|
  @local[:server].config.deny[:post] << uri
end

When(/^I put "(.*?)" with$/) do |url, string|
  @local[:response] = HTTParty.put(url, :body => string)
end

When(/^I post "(.*?)" with$/) do |url, string|
  @local[:response] = HTTParty.post(url, :body => string)
end
