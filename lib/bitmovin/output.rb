# frozen_string_literal: true

require File.expand_path('../helpers', __FILE__)

module Bitmovin
  # Represents a bitmovin Output
  # @see https://bitmovin.com/encoding-documentation/encoder-api-reference-documentation/#/reference/outputs Bitmovin Output docs
  class Output
    include Bitmovin::Helpers

    ##
    #@private
    ATTRIBUTES = %i{
      output_id
      type
      name
      bucket
      region
      access_key
      secret_key
      account_name
      account_key
      container
      prefix
      make_public
      create_sub_directory
      created_at
    }

    ATTRIBUTES.each do |_attr|
      define_method _attr do
        @details[_attr]
      end

      define_method :"#{_attr}=" do |value|
        @details[_attr] = value
      end
    end

    ##
    # @param params [Hash] Output details
    # @option params [String] :type Type of Output
    # @option params [String] :name Name of output profile
    # @option params [String] :bucket S3 Bucket name for s3 output
    # @option params [String] :region ('us-east-1') S3 region of bucket, required for S3 outputs
    # @option params [String] :access_key S3/GCS Access Key, required for S3 outputs
    # @option params [String] :secret_key S3/GCS Secret key, required for S3 outputs
    # @option params [String] :account_name MS Azure account name, required for Azure outputs
    # @option params [String] :account_key MS Azure account key, required for Azure outputs
    # @option params [String] :container Name of Azure storage container
    # @option params [String] :prefix Virtual sub-directory for file
    # @option params [Boolean] :make_public If true, all transfered files can be accessed by their respective URL from anyone
    # @option params [Boolean] :create_sub_directory (true) if true, create a sub directory for your job (<job_id>_<hash>)
    #
    def initialize(params={})
      @details = params
    end

    ##
    # Creates a new bitmovin output
    #
    # @param (#initialize)
    #
    # @return [Bitmovin::Output] Bitmovin Output details
    #
    def self.create(params={})
      new(params).create
    end

    ##
    # Creates a new bitmovin output with params given within initialization
    # @return [Bitmovin::Input] Bitmovin Output details
    #
    def create
      make_create_request
    end

    ##
    # Get bitmovin input details
    # @param reload [Boolean] force data reload from server
    # @return [Hash] output data as a ruby hash
    def details(reload = false)
      return @details if !reload && @details

      reload_details
    end

    class << self
      include Bitmovin::Helpers

      ##
      # Get lsit of available bitmovin outputs (10 per page)
      #
      # @param page [Number] page number
      # @param reload [Boolean] force reload
      #
      # @return [Array<Bitmovin::Output>] array of bitmovin outputs
      #
      def list(page = 1, reload = false)
        var_name = :"@list_p#{ page }"
        val = instance_variable_get var_name

        return val if val && !reload

        get = Net::HTTP::Get.new "/api/outputs/?page=#{ page }", initheaders = headers

        response = Bitmovin.http.request get

        list = prepare_response_json(response.body).map { |output| Bitmovin::Output.new(output) }

        val = instance_variable_set var_name, list
      end
    end

    private

    ##
    # @private
    def make_create_request
      if %w{s3 gcs}.include? @details[:type]
        raise Bitmovin::ApiParameterEmptyError.new(parameter = :access_key) unless @details[:access_key]
        raise Bitmovin::ApiParameterEmptyError.new(parameter = :secret_key) unless @details[:secret_key]
      end

      payload = prepare_request_json @details
      post = Net::HTTP::Post.new "/api/output/create", initheaders = headers
      post.body = payload

      response = Bitmovin.http.request post

      @details = prepare_response_json response.body
      self
    rescue Net::HTTPRequestTimeOut => e
      nil
    end

    ##
    # private
    def reload_details
      get = Net::HTTP::Get.new "/api/output/#{@params[:output_id]}", initheaders = headers
      response = Bitmovin.http.request get

      @details = prepare_response_json response.body
    end
  end
end
