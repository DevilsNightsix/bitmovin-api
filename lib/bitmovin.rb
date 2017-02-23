# frozen_string_literal: true

require 'bitmovin/helpers'
require 'bitmovin/input'
require 'bitmovin/output'
require 'bitmovin/encoding_profile'
require 'bitmovin/transfer_job'
require 'bitmovin/job'

require 'bitmovin/client'

module Bitmovin

  API_URL = 'https://portal.bitcodin.com/api'
  API_URI = URI(API_URL)

  @@api_key = nil
  @@http = Net::HTTP.new API_URI.host, API_URI.port
  @@http.use_ssl = API_URI.scheme == "https"

  class << self
    def api_key=(key)
      @@api_key = key
    end

    def http
      @@http
    end

    def api_key
      @@api_key
    end
  end

  class ApiParameterEmptyError < StandardError

    def initialize(msg = "Is required", parameter)
      @parameter = parameter
      @msg = msg
    end
  end
end
