# frozen_string_literal: true

require 'bitmovin/helpers'

module Bitmovin
  
  API_URL = 'https://portal.bitcodin.com/api'

  include Helpers
  
  @@api_key = nil

  class << self
    def api_key=(key)
      @@api_key = key
    end

    protected

    def api_key
      @@api_key
    end
  end
end
