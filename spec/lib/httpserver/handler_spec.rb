require "spec_helper"
require "nokogiri"

describe HTTPServer do
  around(:each) do |example|
    @server = start_http_server(port)
    example.run
    @server.close
  end
  context "#handle_request" do
    it "should get a page request" do
      response = HTTParty.get("http://localhost:#{port}/index.html")
      response.code.should == 200
      response.body.should include("hello")
    end
    it "should get a directory request" do
      response = HTTParty.get("http://localhost:#{port}/")
      response.code.should == 200
      response.body.should include("index.html")
    end
    it "should handle a non-existant file" do
      response = HTTParty.get("http://localhost:#{port}/does-not-exist")
      response.code.should == 404
      response.body.should include("File not found")
    end
    it "should handle a redirect" do
      @server.config.redirect["/redirect"] = "http://localhost:#{port}/"
      response = HTTParty.get("http://localhost:#{port}/redirect")
      response.code.should == 200
      response.request.path.to_s.should == "http://localhost:#{port}/"
    end
    it "should put a file" do
      filepath = "public/Gemfile"
      File.unlink(filepath) if File.file?(filepath)
      response = HTTParty.put("http://localhost:#{port}/Gemfile",
                              :body => File.read("Gemfile"))
      response.code.should == 200
      File.file?(filepath).should == true
      File.read(filepath).should include("source")
    end
    it "should post a file" do
      response = HTTParty.post("http://localhost:#{port}/index.html", :body => "foo=bar")
      response.code.should == 200
    end
  end

  context "#handle_directory" do
    it "should make sure each entry is a link" do
      response = HTTParty.get("http://localhost:#{port}/")
      response.code == 200
      doc = Nokogiri::HTML(response.body)
      links = doc.css("a")
      links.should_not be_empty
      links.each do |link|
        href = link.attr("href")
        href =~ %r{^/.*} # make sure it's an absolute path
        href.should_not == "/.."
        href.should_not == "/."
      end
    end
  end
end
