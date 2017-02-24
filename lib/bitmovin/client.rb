module Bitmovin

  class Client

    def initialize(api_key)
      Bitmovin.api_key = api_key
    end

    ##
    # Creates a new encoding job
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
    # @return [Bitmovin::Job] a Bitmovin job details
    #
    # @example
    #   client = Bitmovin::Client.new "somefuncykey"
    #
    #   job = client.create_job(
    #     input_id: 1,
    #     output_id: 1,
    #     encoding_profile_id: 1,
    #     manifest_types: ["mpd", "m3u8"]
    #   )
    #
    def create_job(params = {})
      Bitmovin::Job.create(params)
    end

    ##
    # Create new encoding profile
    # @param params Encoding profile video & audio configurations
    # @option params [String] :name Name of new Encoding profile
    # @option params [Number] :rotation Rotation of the video in degrees. A positive value will rotate the video clockwise and a negative one counter clockwise.
    # @option params [Hash] :segment_length Only available using standard speed. Defines the length of a segment. Must be a value between 1 and 9 seconds.
    # @option params [Array<Hash>] :video_stream_configs An array of video profile configs
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
    # @option params [Array<Hash>] :audio_stream_configs An array of audio profile configs
    #   * :default_stream_id ID of the audio stream which should be encoded
    #   * :representation_id ID of the audio stream config
    #   * :bitrate Bitrate of the audio stream. Values must be in the range from 8000 to 256000
    #   * :rate The sample rate the encoded audio should have in Hz. Possible values are: 0, 8000, 11025, 12000, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000
    # @option params [Hash] :watermark_config A watermark config
    #   * :top Distance between the top of the watermark image and the top of the input video
    #   * :left Distance between the left side of the watermark image and the left side of the input video
    #   * :bottom Distance between the bottom of the watermark image and the bottom of the input video
    #   * :right Distance between the right of the watermark image and the right of the input video
    # @option params [Hash] :cropping_config crop configuration
    #   * :top Amount of pixel which will be cropped of the input video from the top.
    #   * :left Amount of pixel which will be cropped of the input video from the left side.
    #   * :bottom Amount of pixel which will be cropped of the input video from the bottom.
    #   * :right Amount of pixel which will be cropped of the input video from the right side.
    #
    # @return [Bitmovin::EncodingProfile] a bitmovin encoding profile details
    #
    # @example
    #   client = Bitmovin::Client.new "somefuncykey"
    #
    #   encoding_profile = client.create_encoding_profile(
    #     name: "New profile",
    #     video_stream_configs: [
    #       {
    #         default_stream_id: 0,
    #         bitrate: 1024000,
    #         profile: "Main",
    #         preset: "Standard",
    #         codec: "h264",
    #         height: 480,
    #         width: 204
    #       }
    #     ],
    #     audio_stream_configs: [
    #       {
    #         default_stream_id: 0,
    #         bitrate: 256000
    #       }
    #     ]
    #   )

    def create_encoding_profile(params = {})
      Bitmovin::EncodingProfile.create(params)
    end

    ##
    #Creates new input
    # @overload create_input(url, params)
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
    #   @example
    #     client = Bitmovin::Client.new "somefuncykey"
    #     input = client.create_input("https://bucket-name.s3.amazonaws.com/path/to/file.txt",
    #       type: 's3',
    #       access_key: "awsS3Key",
    #       secret_key: "awsS3Secret"
    #     )
    #
    # @overload create_input(params)
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
    #   @example
    #     client = Bitmovin::Client.new "somefuncykey"
    #
    #     client.create_input(
    #       bucket: "bucket-name",
    #       object_key: "/path/to/file.txt",
    #       type: 's3',
    #       access_key: "awsS3Key",
    #       secret_key: "awsS3Secret"
    #     )
    #
    #
    # @return [Bitmovin::Input] a bitmovin input details
    #
    def create_input(*args)
      Bitmovin::Input.create(*args)
    end

    ##
    # Create a new Bitmovin Output
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
    # @example
    #   client = Bitmovin::Client.new "somefuncykey"
    #
    #   client.create_input(
    #     type: 's3',
    #     access_key: 'awsS3Key',
    #     secret_key: 'aswS3Secret',
    #     name: 'file.txt',
    #     prefix: '/path/to',
    #     bucket: "bucket-name"
    #   )
    #
    #
    # @return [Bitmovin::Output] Bitmovin Output details
    #
    def create_output(params = {})
      Bitmovin::Output.create(params)
    end

    ##
    # Transfer job result to destination outputs
    # @option params job_id [Integer] Job-ID
    # @option params output_id [Integer] Output-ID
    #
    # @return [Bitmovin::TransferJob] Transfer job details
    #
    def transfer_job(params={})
      Bitmovin::TransferJob.create(params)
    end

    ##
    # Get list of available encoding profiles by pages per 10
    # @param page [Integer] number of page
    # @return [Array<Bitmovin::EncodingProfile>] array of encoding profiles
    #
    def get_encoding_profiles_list(page = 1)
      Bitmovin::EncodingProfile.list(page)
    end

    ##
    # Get list of available jobs (10 Jobs per page)
    # @param status [String, Symbol] Available values: all | finished | enqueued | inprogress | error
    # @param page [Integer] number of page
    # @param reload [Integer] Force reload from server
    # @return [Array<Bitmovin::Job>] array of encoding jobs
    #
    def get_jobs_list(status = :all, page = 1, reload = false)
      Bitmovin::Job.list(status, page, reload)
    end

    ##
    # Get lsit of available bitmovin inputs (10 per page)
    #
    # @param page [Number] page number
    # @param reload [Boolean] force reload
    #
    # @return [Array<Bitmovin::Input>] array of bitmovin inputs
    #
    def get_inputs_list(page = 1, reload = false)
      Bitmovin::Input.list(page, reload)
    end

    ##
    # Get lsit of available bitmovin outputs (10 per page)
    #
    # @param page [Number] page number
    # @param reload [Boolean] force reload
    #
    # @return [Array<Bitmovin::Output>] array of bitmovin outputs
    #
    def get_outputs_list(page = 1, reload = false)
      Bitmovin::Output.list(page, reload)
    end
  end
end
