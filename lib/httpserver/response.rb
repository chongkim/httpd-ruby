class HTTPServer
  class Response
    attr_accessor :code, :content
    def initialize(request)
      @request = request
      @content = ""
      @code = 500
    end
    def status
      "HTTP/1.0 #{code} #{code_name}"
    end
    def <<(content)
      @content << content
    end
    def code_name
      case code
      when 200 then "OK"
      when 404 then "Not found"
      when 500 then "Internal Server Error"
      else "Unknown"
      end
    end
  end
end 
