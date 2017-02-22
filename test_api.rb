require 'rack'
require "apib/mock_server"

base_url = "http://private-anon-6f2a0baf67-bitcodinrestapi.apiary-proxy.com/api"
api_b = File.expand_path('../bitcodinrestapi.apib', __FILE__)
blueprint = File.read(api_b)

app = Apib::MockServer.new(base_url, blueprint)

Rack::Handler.default.run app
