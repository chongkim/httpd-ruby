require "httpserver/helper"

class HTTPServer
  def handle_request(request, response)
    filename = pathname(request.filename)
    return handle_directory(request, response) if File.directory?(filename)
    return handle_file(request, response) if File.file?(filename)
    return handle_file_not_found(request, response)
  end

  def handle_file(request, response)
    File.open(pathname(request.filename)) do |f|
      response.code = 200
      response << f.read
    end
  end

  def handle_directory(request, response)
    response.code = 200
    response << Dir.entries(pathname(request.filename)).join("<br />\n")
  end

  def handle_file_not_found(request, response)
    response.code=404
    response << "<h1>File not found</h1>"
  end
end
