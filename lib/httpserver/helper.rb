class HTTPServer
  def public_dir
    return "public" if @public_dir.nil?
    @public_dir
  end

  def public_dir=(val)
    @public_dir = val
    @public_dir.chomp!("/") if @public_dir.end_with?("/")
  end

  def pathname(filename)
    "#{public_dir}#{filename}"
  end
end

