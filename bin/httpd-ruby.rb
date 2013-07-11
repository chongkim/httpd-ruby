#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.expand_path("../../lib", __FILE__)

require "autoreload"

autoreload(:interval => 2) {
  require "httpserver"
}

require "optparse"

options = {
  :port => 5000,
  :dir => "public"
}

ARGV.options do |opts|
  opts.on("-p <port>", "port", Integer) { |port| options[:port] = port }
  opts.on("-d <dir>", "directory") { |dir| options[:dir] = dir }
end.parse!

server = HTTPServer.new(options[:port])
server.public_dir = options[:dir]
server.debug = true
server.config.redirect["/redirect"] = "http://localhost:#{options[:port]}/"
server.config.deny[:put] << "/file1"
server.config.deny[:post] << "/text-file.txt"
server.start_loop

