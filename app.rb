require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?

require File.join(File.dirname(__FILE__), 'lib/mirror.rb')

raise Exception.new("DOMAIN env variable must be set") unless ENV["DOMAIN"]

def extract_request_domain(host, current_domain)
  host.chomp(".#{current_domain}")
end

get '/', :host_name => "www.#{ENV["DOMAIN"]}" do
  # todo
end

get '*' do
  domain = extract_request_domain(request.host, ENV["DOMAIN"])
  path   = request.path
  query  = request.query_string
  begin
    mirror = Mirror.new(domain, path, query)
    [200, mirror.headers, mirror.content]
  rescue URI::InvalidURIError
    [400, {}, "URL required"]
  end
end
