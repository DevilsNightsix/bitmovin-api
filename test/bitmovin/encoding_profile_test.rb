require 'minitest/autorun'
require 'test_helper'
require 'bitmovin/encoding_profile'

class EncodingProfileTest < MiniTest::Test

  def test_create_on_class
    Bitmovin.api_key = "somefuncykey"

    encoding_profile = Bitmovin::EncodingProfile.create(
      name: "New profile",
      video_stream_configs: [
        {
          default_stream_id: 0,
          bitrate: 1024000,
          profile: "Main",
          preset: "Standard",
          codec: "h264",
          height: 480,
          width: 204
        }
      ],
      audio_stream_configs: [
        {
          default_stream_id: 0,
          bitrate: 256000
        }
      ]
    )

    assert encoding_profile.created_at != nil
  end

  def test_list_on_class
    Bitmovin.api_key = "somefuncykey"

    list = Bitmovin::EncodingProfile.list

    assert_kind_of Bitmovin::EncodingProfile, list.sample
  end

  def test_get_details
    Bitmovin.api_key = "somefuncykey"

    encoding_profile = Bitmovin::EncodingProfile.new encoding_profile_id: 1

    assert encoding_profile.details(true)[:created_at] != nil
  end
end

