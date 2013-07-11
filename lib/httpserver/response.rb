class HTTPServer
  class Response
    attr_accessor :code, :body, :headers, :request
    def initialize(request)
      @request = request
      @body = ""
      @code = 500
      @headers = {}
    end
    def status
      "HTTP/1.0 #{code} #{code_name}"
    end
    def <<(body)
      @body << body
    end
    def code_name
      case code
      when 100 then "Continue"
      when 101 then "Switching Protocols"
      when 200 then "OK"
      when 201 then "Created"
      when 202 then "Accepted"
      when 203 then "Non-Authoritative Information"
      when 204 then "No Content"
      when 205 then "Reset Content"
      when 206 then "Partial Content"
      when 207 then "Multi-Status"
      when 208 then "Already Reported"
      when 226 then "IM Used"
      when 300 then "Multiple Choices"
      when 301 then "Moved Permanently"
      when 302 then "Found"
      when 303 then "See Other"
      when 304 then "Not Modified"
      when 305 then "Use Proxy"
      when 306 then "Switch Proxy"
      when 307 then "Temporary Redirect"
      when 308 then "Permanent Redirect"
      when 400 then "Bad Request"
      when 401 then "Unauthorized"
      when 402 then "Payment Required"
      when 403 then "Forbidden"
      when 404 then "Not Found"
      when 405 then "Method Not Allowed"
      when 406 then "Not Acceptable"
      when 407 then "Proxy Authentication Required"
      when 408 then "Request Timeout"
      when 409 then "Conflict"
      when 410 then "Gone"
      when 411 then "Length Required"
      when 412 then "Precondition Failed"
      when 413 then "Request Entity Too Large"
      when 414 then "Request-URI Too Long"
      when 415 then "Unsupported Media Type"
      when 416 then "Requested Range Not Satisfiable"
      when 417 then "Expectation Failed"
      when 418 then "I'm a teapot"
      when 419 then "Authentication Timeout"
      when 420 then "Enhance Your Calm"
      when 422 then "Unprocessable Entity"
      when 423 then "Locked"
      when 424 then "Method Failure"
      when 425 then "Unordered Collection"
      when 426 then "Upgrade Required"
      when 428 then "Precondition Required"
      when 429 then "Too Many Requests"
      when 431 then "Request Header Fields Too Large"
      when 444 then "No Response"
      when 449 then "Retry With"
      when 450 then "Blocked by Windows Parental Controls"
      when 451 then "Redirect"
      when 494 then "Request Header Too Large"
      when 495 then "Cert Error"
      when 496 then "No Cert"
      when 497 then "HTTP to HTTPS"
      when 499 then "Client Closed Request"
      when 500 then "Internal Server Error"
      when 501 then "Not Implemented"
      when 502 then "Bad Gateway"
      when 503 then "Service Unavailable"
      when 504 then "Gateway Timeout"
      when 505 then "HTTP Version Not Supported"
      when 506 then "Variant Also Negotiates"
      when 507 then "Insufficient Storage"
      when 508 then "Loop Detected"
      when 509 then "Bandwidth Limit Exceeded"
      when 510 then "Not Extended"
      when 511 then "Network Authentication Required"
      when 598 then "Network read timeout error"
      when 599 then "Network connect timeout error"
      else "Unknown"
      end
    end
  end
end 
