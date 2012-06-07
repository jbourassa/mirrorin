require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?

require File.join(File.dirname(__FILE__), 'lib/gh_serve.rb')

GhServe.serving_url = "http://growing-sunrise-3357.heroku.com/serve?url=%s"

get '/serve' do
  begin
    gh_serve = GhServe.new params[:url], params.delete(:url)
    [200, gh_serve.headers, gh_serve.parsed_content]
  rescue InvalidUrl
    [400, {}, "URL required"]
  end
end
