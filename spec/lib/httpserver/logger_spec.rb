require "spec_helper"

describe HTTPServer::Logger do
  let(:logger) { HTTPServer::Logger.new }
  let(:debug_filename) { "log/httpd-ruby-rspec.debug.log" }
  context "#debug" do
    it "should default to false" do
      logger.debug?.should == false
    end
    it "should not log if debug is set to false" do
      logger.debug = false
      logger.debug_filename = debug_filename
      File.unlink(debug_filename) if File.file?(debug_filename)
      logger.debug("foo")
      File.file?(debug_filename).should == false
    end
    it "should log if debug is set to true" do
      logger.debug = true
      logger.debug_filename = debug_filename
      File.unlink(debug_filename) if File.file?(debug_filename)
      logger.debug("foo")
      File.file?(debug_filename).should == true
      File.open(debug_filename) do |f|
        f.read.should include("foo")
      end
    end
  end
end
