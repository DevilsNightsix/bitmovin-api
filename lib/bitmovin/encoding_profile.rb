# frozen_string_literal: true

require File.expand_path('../helpers', __FILE__)

module Bitmovin
  # Represents a bitmovin encoding profile
  # @see https://bitmovin.com/encoding-documentation/encoder-api-reference-documentation/#/reference/encoding-profiles Bitmovin Encoding Profiles docs
  class EncodingProfile

    include Bitmovin::Helpers

    ATTRIBUTES = %i{
      encoding_profile_id
      video_stream_configs
      audio_stream_configs
      watermark_config
      created_at
      type
      name
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
    # @param params Encoding profile video & audio configurations
    # * :name Name of new Encoding profile
    # * :rotation Rotation of the video in degrees. A positive value will rotate the video clockwise and a negative one counter clockwise.
    # * :segment_length Only available using standard speed. Defines the length of a segment. Must be a value between 1 and 9 seconds.
    # * :video_stream_configs An array of video profile configs
    #   * :default_stream_id ID of the video stream which should be encoded
    #   * :representation_id ID of the video stream config
    #   * :bitrate Bitrate of the video stream. Value must be in the range from 32000 to 20000000
    #   * :profile Profile which should be used to encode video stream. Possible values are: baseline, main, high
    #   * :preset Preset which should be used to encode video stream. Possible values are: standard, professional, premium
    #   * :height Video-Width in px, must be in the range from 128 to 7680
    #   * :width Video-Height in px, must be in the range from 96 to 4320
    #   * :rate Only available using standard speed. The sample rate the encoded video should have in FPS. Values must be in the range from 1 to 120
    #   * :codec Only available using premium speed. Sets the video codec used for encoding. Possible values are: h264, hevc. Default value is h264.
    #   * :b_frames Sets the amount of B-Frames. Valid value range: 0 - 16
    #   * :ref_frames Sets the amount of Reference-Frames. Valid value range: 0 - 16
    #   * :qp_min Sets the minimum of quantization-factor. Valid value range: 0 - 69
    #   * :qp_max Sets the maximum of quantization-factor. Valid value range: 0 - 69
    #   * :mv_prediction_mode Sets the Motion Vector Prediction Mode. Valid values: none, spatial, temporal, auto
    #   * :mv_search_range_max Sets the maximum Motion-Vector-Search-Range. Valid value range: 16 - 24
    #   * :no_cabac Disable CABAC.
    # * :audio_stream_configs An array of audio profile configs
    #   * :default_stream_id ID of the audio stream which should be encoded
    #   * :representation_id ID of the audio stream config
    #   * :bitrate Bitrate of the audio stream. Values must be in the range from 8000 to 256000
    #   * :rate The sample rate the encoded audio should have in Hz. Possible values are: 0, 8000, 11025, 12000, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000
    # * :watermark_config A watermark config
    #   * :top Distance between the top of the watermark image and the top of the input video
    #   * :left Distance between the left side of the watermark image and the left side of the input video
    #   * :bottom Distance between the bottom of the watermark image and the bottom of the input video
    #   * :right Distance between the right of the watermark image and the right of the input video
    # * :cropping_config
    #   * :top Amount of pixel which will be cropped of the input video from the top.
    #   * :left Amount of pixel which will be cropped of the input video from the left side.
    #   * :bottom Amount of pixel which will be cropped of the input video from the bottom.
    #   * :right Amount of pixel which will be cropped of the input video from the right side.
    #
    def initialize(params={})
      @details = params
    end

    ##
    # Create encoding profile with params given within initialization
    #
    # return [Bitmovin::EncodingProfile] create bitmovin encoding profile
    def create
      make_create_request
      self
    end

    ##
    # @param params Encoding profile video & audio configurations
    # * :name Name of new Encoding profile
    # * :rotation Rotation of the video in degrees. A positive value will rotate the video clockwise and a negative one counter clockwise.
    # * :segment_length Only available using standard speed. Defines the length of a segment. Must be a value between 1 and 9 seconds.
    # * :video_stream_configs An array of video profile configs
    #   * :default_stream_id ID of the video stream which should be encoded
    #   * :representation_id ID of the video stream config
    #   * :bitrate Bitrate of the video stream. Value must be in the range from 32000 to 20000000
    #   * :profile Profile which should be used to encode video stream. Possible values are: baseline, main, high
    #   * :preset Preset which should be used to encode video stream. Possible values are: standard, professional, premium
    #   * :height Video-Width in px, must be in the range from 128 to 7680
    #   * :width Video-Height in px, must be in the range from 96 to 4320
    #   * :rate Only available using standard speed. The sample rate the encoded video should have in FPS. Values must be in the range from 1 to 120
    #   * :codec Only available using premium speed. Sets the video codec used for encoding. Possible values are: h264, hevc. Default value is h264.
    #   * :b_frames Sets the amount of B-Frames. Valid value range: 0 - 16
    #   * :ref_frames Sets the amount of Reference-Frames. Valid value range: 0 - 16
    #   * :qp_min Sets the minimum of quantization-factor. Valid value range: 0 - 69
    #   * :qp_max Sets the maximum of quantization-factor. Valid value range: 0 - 69
    #   * :mv_prediction_mode Sets the Motion Vector Prediction Mode. Valid values: none, spatial, temporal, auto
    #   * :mv_search_range_max Sets the maximum Motion-Vector-Search-Range. Valid value range: 16 - 24
    #   * :no_cabac Disable CABAC.
    # * :audio_stream_configs An array of audio profile configs
    #   * :default_stream_id ID of the audio stream which should be encoded
    #   * :representation_id ID of the audio stream config
    #   * :bitrate Bitrate of the audio stream. Values must be in the range from 8000 to 256000
    #   * :rate The sample rate the encoded audio should have in Hz. Possible values are: 0, 8000, 11025, 12000, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000
    # * :watermark_config A watermark config
    #   * :top Distance between the top of the watermark image and the top of the input video
    #   * :left Distance between the left side of the watermark image and the left side of the input video
    #   * :bottom Distance between the bottom of the watermark image and the bottom of the input video
    #   * :right Distance between the right of the watermark image and the right of the input video
    # * :cropping_config
    #   * :top Amount of pixel which will be cropped of the input video from the top.
    #   * :left Amount of pixel which will be cropped of the input video from the left side.
    #   * :bottom Amount of pixel which will be cropped of the input video from the bottom.
    #   * :right Amount of pixel which will be cropped of the input video from the right side.
    #
    def self.create(params={})
      new(params).create
    end

    ##
    # Get encoding profile details as hash
    # @param reload [Boolean] Reload details from server
    # @return [Hash] encoding profile details
    #
    def details(reload = false)
      return @details unless reload

      reload_details
    end

    class << self
      include Bitmovin::Helpers

      ##
      # Get list of available encoding profiles by pages per 10
      # @param page [Integer] number of page
      # @return [Array<Bitmovin::EncodingProfile>] array of encoding profiles
      #
      def list(page = 1)
        get = Net::HTTP::Get.new "/api/encoding-profiles/#{page}", initheaders = headers

        response = Bitmovin.http.request get

        json = prepare_response_json(response.body)

        json[:profiles].map { |p| Bitmovin::EncodingProfile.new(p) }
      end
    end

    private

    def reload_details
      get = Net::HTTP::Get.new "/api/encoding-profile/#{encoding_profile_id}"

      response = Bitmovin.http.request get

      @details = prepare_response_json(response.body)
      @details
    end

    def make_create_request
      payload = prepare_request_json(@details)

      post = Net::HTTP::Post.new "/api/encoding-profile/create", initheaders = headers
      post.body = payload

      response = Bitmovin.http.request post

      @details = prepare_response_json(response.body)
      self
    end

  end
end
