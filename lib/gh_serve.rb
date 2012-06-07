require 'net/http'
require 'nokogiri'

class GhServe
  @@serving_url = 'http://to-serve.com/serve?url=%s'

  def self.serving_url= url
    @@serving_url = url
  end

  def self.serving_url
    @@serving_url
  end

  def initialize url, params = {}
    @url = url
    @params = params
  end

  def headers
    { "Content-Type" => MimeTypes.for_ext(url_ext, :html) }
  end

  def url_ext
    @url.split('.').last
  end

  def parsed_content
    ext = url_ext
    if respond_to? "parse_#{url_ext}"
      send "parse_#{url_ext}"
    else
      raw_content
    end
  end

  def parse_html
    doc = Nokogiri::HTML::Document.parse raw_content

    node_types = {
      'script' => 'src',
      'img'    => 'src',
      'link'   => 'href',
    }

    node_types.each do |type, attr|
      puts "#{type}[#{attr}]"
      doc.css("#{type}[#{attr}]").each do |node|
        node[attr] = new_file_url node[attr]
      end
    end

    doc.to_html
  end

  def raw_content
    @raw_content ||= fetch_raw_content
  end

  def new_file_url current_url
    root_doc_url = URI(@url)
    current_uri  =  URI(current_url)

    if current_uri.absolute?
      current_url
    elsif current_uri.path.match /^\//
        root_doc_url.path = current_uri.path
        format @@serving_url, root_doc_url.to_s
    else
        format @@serving_url, "#{File.dirname(@url)}/#{current_uri}"
    end
  end

  private

  def fetch_raw_content
    begin
      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
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
