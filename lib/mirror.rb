require 'net/http'
require 'rack/mime'

class Mirror

  @@https_domains = ['raw.github.com']

  def initialize domain, url, params = {}
    @domain = domain
    @url = url
  end

  def headers
    { "Content-Type" => Rack::Mime.mime_type(url_ext, "text/html") }
  end

  def content
    @content ||= fetch
  end

  def url_ext
    File.extname @url
  end

  def build_uri
    scheme =  https? ? 'https' : 'http'
    "#{scheme}://#{@domain}#{@url}"
  end

  def https?
    @@https_domains.include?(@domain)
  end

  private

  def fetch
    begin
      uri = URI.parse(build_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      if https?
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request).body
    rescue ArgumentError, NoMethodError, SocketError
      raise URI::InvalidURIError
    end
  end

end
