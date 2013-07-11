require "httpserver/helper"

class HTTPServer
  def handle_request(request, response)
    raise "crash" if request.http_method == :crash
    return handle_redirect(request, response) if config.redirect[request.filename]
    filename = pathname(request.filename)
    case request.http_method
    when :get
      return handle_directory(request, response) if File.directory?(filename)
      return handle_file(request, response) if File.file?(filename)
      return handle_file_not_found(request, response)
    when :put
      return handle_put_file(request, response)
      response.code = 405
    when :post
      return handle_post(request, response) if File.file?(filename)
    else
      response.code = 400
    end
  rescue Exception => e
    response.code = 500
    response.body = nil
    logger.debug(:handler, $!)
    logger.debug(:handler, $@)
  end

  def handle_redirect(request, response)
    response.headers["Location"] = config.redirect[request.filename]
    response.code = 301
  end

  def handle_put_file(request, response)
    File.open(pathname(request.filename), "w") do |f|
      response.code = 200
      f.write(request.body)
    end
  end

  def handle_post(request, response)
    File.open(pathname(request.filename)) do |f|
      response.code = 200
      response << f.read
    end
  end

  def handle_file(request, response)
    File.open(pathname(request.filename)) do |f|
      response.code = 200
      response << f.read
    end
  end

  def handle_directory(request, response)
    dir = request.filename
    links = Dir.entries(pathname(request.filename)).map { |file|
      uri = "#{dir}#{file}"
      "<a href=\"#{uri}\">#{file}</a>" if uri != "/.." && file != "."
    }.compact
    response.code = 200
    response << <<-EOF
<html>
<body>
<dl>
<dt>Directory of #{dir}</dt>
<dd>#{ links.join("</dd>\n<dd>") }</dd>
</dl>
</body>
</html>
    EOF
  end

  def handle_file_not_found(request, response)
    response.code = 404
    response << <<-EOF
<html>
<body>
<h1>File not found</h1>"
</body>
</html>
    EOF
  end
end
