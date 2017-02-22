# frozen_string_literal: true

require 'minitest/color'
require "apib/mock_server"
require "webmock"

require 'bitmovin'

base_url = "http://private-anon-6f2a0baf67-bitcodinrestapi.apiary-proxy.com/api"
api_b = File.expand_path('../../bitcodinrestapi.apib', __FILE__)
blueprint = File.read(api_b)

app = Apib::MockServer.new(base_url, blueprint)
WebMock::StubRegistry.instance.register_request_stub(
  WebMock::RequestStub.new(:any, /#{base_url}/)
).to_rack(app)

module Bitmovin
  send(:remove_const, :API_URL)
  send(:remove_const, :API_URI)
  
  API_URL = "http://private-anon-6f2a0baf67-bitcodinrestapi.apiary-proxy.com/api"
  API_URI = URI(API_URL)

  @@http = Net::HTTP.new API_URI.host, API_URI.port
  @@http.use_ssl = API_URI.scheme == "https"
  @@http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end
