#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.expand_path("../../lib", __FILE__)

require "httpserver"

server = HTTPServer.new(5000)
server.public_dir = "/Users/ckim/clone/cob_spec/public/"
server.start_loop

