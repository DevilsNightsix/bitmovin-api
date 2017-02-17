# frozen_string_literal: true

require 'bitmovin'

module Bitmovin
  send(:remove_const, :API_URL)
  send(:remove_const, :API_URI)
  
  API_URL = "http://private-anon-6f2a0baf67-bitcodinrestapi.apiary-mock.com/api"
  API_URI = URI(API_URL)

  @@http = Net::HTTP.new API_URI.host, API_URI.port
  @@http.use_ssl = API_URI.scheme == "https"
end
