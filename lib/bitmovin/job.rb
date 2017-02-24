# frozen_string_literal: true

require File.expand_path('../helpers', __FILE__)

module Bitmovin
  # Represents a bitmovin Job
  # @see https://bitmovin.com/encoding-documentation/encoder-api-reference-documentation/#/reference/jobs Bitmovin Job docs
  class Job
    include Bitmovin::Helpers

    ATTRIBUTES = %i{
      job_id
      input_id
      output_id
      speed
      encoding_profile_id
      audio_meta_data
      manifest_types
      deinterlace
      extract_closed_captinos
      merge_audio_channel_configs
      duration
      start_time
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

    #
    # @param params [Hash] Job details
    # @option params input_id [Integer] Job input id
    # @option params output_id [Integer] Job output id
    # @option params encoding_profile_id [Integer] Encoding profile id
    # @option params audio_meta_data [Hash] Meta data of the audio streams (Only available when using standard as speed setting)
    #   * :default_stream_id (Integer) - Default stream id of the audio stream
    #   * :language (String) - Language abbreviation [ISO 639-1]
    #   * :label (String) - Label of the language field
    # @option params manifest_types [Array<String>] Available values: mpd | m3u8
    # @option params extract_closed_captinos [Boolean] Extract closed captions from the input file
    # @option params deinterlace [Boolean] Create de-interlaced output
    # @option params merge_audio_channel_configs [Hash] Merge multiple mono audio input streams to stereo or 5.1 audio streams (Only available when using standard as speed setting)
    #  * :audio_channels [Array] - Array of mono input streams
    #
    def initialize(params={})
      @details = params
    end

    #
    # @param params [Hash] Job details
    # @option params input_id [Integer] Job input id
    # @option params output_id [Integer] Job output id
    # @option params encoding_profile_id [Integer] Encoding profile id
    # @option params audio_meta_data [Hash] Meta data of the audio streams (Only available when using standard as speed setting)
    #   * :default_stream_id (Integer) - Default stream id of the audio stream
    #   * :language (String) - Language abbreviation [ISO 639-1]
    #   * :label (String) - Label of the language field
    # @option params manifest_types [Array<String>] Available values: mpd | m3u8
    # @option params extract_closed_captinos [Boolean] Extract closed captions from the input file
    # @option params deinterlace [Boolean] Create de-interlaced output
    # @option params merge_audio_channel_configs [Hash] Merge multiple mono audio input streams to stereo or 5.1 audio streams (Only available when using standard as speed setting)
    #  * :audio_channels [Array] - Array of mono input streams
    #
    def self.create(params={})
      new(params).create
    end

    ##
    # Creates a new bitmovin encoding job with params given within initialization
    # @return [Bitmovin::Job] Bitmovin Job details
    def create
      make_create_request
    end

    ##
    # Get bitmovin encoding job details
    # @param reload Force reload from server
    # @return [Hash] Bitmovin Job details
    def details(reload = false)
      return @details unless reload

      reload_details
    end

    # Get bitmovin encoding job status
    # @param reload Force reload from server
    # @return [Hash] Bitmovin Job details
    def status(reload = false)
      return @status if !reload && @status

      reload_status
    end

    # Get bitmovin encoding job status
    # @param reload Force reload from server
    # @return [Hash] Bitmovin Job details
    def manifest(reload = false)
      return @manifest if !reload && @manifest

      reload_manifest
    end

    class << self
      include Bitmovin::Helpers

      ##
      # Get list of available jobs (10 Jobs per page)
      # @param status [String, Symbol] Available values: all | finished | enqueued | inprogress | error
      # @param page [Integer] number of page
      # @param reload [Integer] Force reload from server
      # @return [Array<Bitmovin::Job>] array of encoding jobs
      #
      def list(status = :all, page = 1, reload = false)
        var_name = :"@#{status}_list#{ page }"

        val = instance_variable_get var_name

        return val if val && !reload

        get = Net::HTTP::Get.new "/api/jobs/#{ page }/#{ status }", initheaders = headers

        response = Bitmovin.http.request get

        json = prepare_response_json(response.body)
        
        value_to_set = json[:jobs].map { |p| Bitmovin::Job.new(p) }

        instance_variable_set var_name, value_to_set
      end
    end

    private

    def reload_manifest
      get = Net::HTTP::Get.new "/api/job/#{ @details[:job_id] }/manifest-info", initheaders = headers

      response = Bitmovin.http.request get

      @manifest = prepare_response_json response.body
      @manifest
    end

    def reload_status
      get = Net::HTTP::Get.new "/api/job/#{ @details[:job_id] }/status", initheaders = headers

      response = Bitmovin.http.request get

      @status = prepare_response_json response.body
      @status
    end

    def reload_details
      get = Net::HTTP::Get.new "/api/job/#{ @details[:job_id] }", initheaders = headers

      response = Bitmovin.http.request get

      @details = prepare_response_json response.body
      @details
    end

    def make_create_request
      payload = prepare_request_json @details

      post = Net::HTTP::Post.new "/api/job/create", initheaders = headers
      post.body = payload

      response = Bitmovin.http.request post

      @details = prepare_response_json response.body
      self
    end
  end
end
