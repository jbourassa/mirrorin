require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?

require File.join(File.dirname(__FILE__), 'lib/gh_serve.rb')

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
  begin
    gh_serve = GhServe.new(domain, path)
    [200, gh_serve.headers, gh_serve.content]
  rescue URI::InvalidURIError
    [400, {}, "URL required"]
  end
end
