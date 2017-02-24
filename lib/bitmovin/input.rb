# frozen_string_literal: true

require File.expand_path('../helpers', __FILE__)

module Bitmovin
  # Represents a bitmovin input
  # @see https://bitmovin.com/encoding-documentation/encoder-api-reference-documentation/#/reference/inputs/ Bitmovin Input docs
  class Input

    include Bitmovin::Helpers

    ATTRIBUTES = %i{
      input_id
      async
      type
      url
      username
      password
      created_at
      region
      bucket
      object_key
      access_key
      secret_key
      account_name
      account_key
      container
      min_bandwidth
      max_bandwidth
    }

    ATTRIBUTES.each do |_attr|
      define_method _attr do
        @params[_attr]
      end

      define_method :"#{_attr}=" do |value|
        @params[_attr] = value
      end
    end


    attr_reader :params, :url

    #
    # @overload initialize(url, params)
    #   @param url [String] url of input for URL, S3 or Aspera inputs
    #   @param params [String] input params
    #   @option params {Boolean] :async Create input async
    #   @option params [String] :type Type of input
    #   @option params [String] :username Basic auth username
    #   @option params [String] :password Basic auth password
    #   @option params [String] :region ('us-east-1') S3 bucket region
    #   @option params [String] :bucket S3 bucket name for s3 input, also can be infered from url
    #   @option params [String] :object_key S3 object name with containing folder, can be infered from url
    #   @option params [String] :access_key S3 or GCS access key, required for S3 or GCS inputs
    #   @option params [String] :secret_key S3 or GCS secret, required for S3 or GCS inputs
    #   @option params [String] :account_name MS Azure account name, required for Azure inputs
    #   @option params [String] :account_key MS Azure account key, required for Azure inputs
    #   @option params [String] :container MS Azure storage container name
    #   @option params [String] :min_bandwidth, Minimal download bandwidth
    #   @option params [String] :max_bandwidth, Maximal download bandwidth
    #
    # @overload initialize(params)
    #   @param params [String] input params
    #   @option params {Boolean] :async Create input async
    #   @option params [String] :type Type of input
    #   @option params [String] :url Aspera/Azure file url
    #   @option params [String] :username Basic auth username
    #   @option params [String] :password Basic auth password
    #   @option params [String] :region ('us-east-1') S3 bucket region
    #   @option params [String] :bucket S3 bucket name for s3 input, also can be infered from url
    #   @option params [String] :object_key S3 object name with containing folder, can be infered from url
    #   @option params [String] :access_key S3 or GCS access key, required for S3 or GCS inputs
    #   @option params [String] :secret_key S3 or GCS secret, required for S3 or GCS inputs
    #   @option params [String] :account_name MS Azure account name, required for Azure inputs
    #   @option params [String] :account_key MS Azure account key, required for Azure inputs
    #   @option params [String] :container MS Azure storage container name
    #   @option params [String] :min_bandwidth, Minimal download bandwidth
    #   @option params [String] :max_bandwidth, Maximal download bandwidth
    #
    #
    # @return [Hash] Input details as a hash
    #
    def initialize(*args)
      @params = args.pop

      @url = args.pop if args.length == 1

      if @url
        @params[:bucket] = extract_bucket(url) if !@params[:bucket] && @params[:type] == "s3"
        @params[:object_key] = extract_object_key(url) if !@params[:object_key]  && @params[:type] == "s3"
        @params[:url]
      end
    end

    ##
    # Creates a new bitmovin input
    #
    # @param (#initialize)
    #
    # @return [Bitmovin::Input] Bitmovin Input details
    #
    def self.create(*args)
      new(*args).create
    end

    ##
    # Creates a new bitmovin input with params given within initialization
    # @return [Bitmovin::Input] Bitmovin Input details
    #
    def create
      make_create_request
    end

    ##
    # Get bitmovin input details
    # @param reload [Boolean] force data reload from server
    #
    def details(reload = false)
      return @params if !reload && @params

      reload_details
    end


    class << self
      include Bitmovin::Helpers


      ##
      # Get lsit of available bitmovin inputs (10 per page)
      #
      # @param page [Number] page number
      # @param reload [Boolean] force reload
      #
      # @return [Array<Bitmovin::Input>] array of bitmovin inputs
      #
      def list(page = 1, reload = false)
        var_name = :"@list_p#{ page }"
        val = instance_variable_get(var_name)

        return val if val && !reload

        get = Net::HTTP::Get.new "/api/inputs/#{ page }", initheaders = headers

        response = Bitmovin.http.request get

        list = prepare_response_json(response.body).map { |input| Bitmovin::Input.new(input) }

        val = instance_variable_set(var_name, list)
      end

    end

    private

    ##
    #@private
    def make_create_request
      if %w{s3 gcs}.include? params[:type]
        raise Bitmovin::ApiParameterEmptyError.new(parameter = :access_key) unless params[:access_key]
        raise Bitmovin::ApiParameterEmptyError.new(parameter = :secret_key) unless params[:secret_key]
      end

      payload = prepare_request_json(params)
      path = params[:async] ? "/api/input/createasync" : "/api/input/create"
      post = Net::HTTP::Post.new path, initheaders = headers
      post.body = payload

      response = Bitmovin.http.request post

      @params = prepare_response_json(response.body)
      self
    rescue Net::HTTPRequestTimeOut => e
      nil
    end

    ##
    #@private
    def reload_details
      get = Net::HTTP::Get.new "/api/input/#{@params[:input_id]}", initheaders = headers

      response = Bitmovin.http.request get

      @params = prepare_response_json(response.body)
    end
  end
end
