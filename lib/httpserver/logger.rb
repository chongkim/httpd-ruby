class HTTPServer
  class Logger
    def initialize
      @debug = false
    end
    def debug=(val)
      @debug = val
    end
    def debug?
      @debug
    end
    def debug(*messages)
      return if !debug?
      output = messages.join(": ")
      puts output
      debug_file.puts output
      debug_file.flush
    end
    def debug_filename=(filename)
      @debug_filename = filename
    end
    def debug_filename
      @debug_filename ||= "log/httpd-ruby.debug.log"
    end
    def debug_file
      if @debug_file.nil?
        Dir.mkdir("log") if !File.directory?("log")
        @debug_file = File.open(debug_filename, "w+")
      end
      @debug_file
    end
  end
end

