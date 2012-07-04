require 'net/http'

class GhServe

  @@https_domains = ['raw.github.com']

  def initialize domain, url, params = {}
    @domain = domain
    @url = url
  end

  def headers
    { "Content-Type" => MimeTypes.for_ext(url_ext, :html) }
  end

  def content
    @content ||= fetch
  end

  def url_ext
    @url.split('.').last.to_sym
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

class MimeTypes
  TYPES = {
    html: 'text/html',
    htm:  'text/html',
    css:  'text/css',
    js:   'application/javascript',
    jpg:  'image/jpeg',
    jpeg: 'image/jpeg',
    png:  'image/png',
    gif:  'image/gif',
  }

  def self.for_ext type, fallback
    TYPES[type.to_sym] || TYPES[fallback.to_sym]
  end
end
