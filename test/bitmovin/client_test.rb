require 'minitest/autorun'
require 'test_helper'
require 'bitmovin/client'

class BitmovinClientTest < MiniTest::Test

  extend Minitest::Spec::DSL

  let(:api_key) { "somefuncyapikey" }

  let(:client) { Bitmovin::Client.new(api_key) }

  def test_create_input_via_client
    input = client.create_input(
      bucket: "bucket-name",
      object_key: "/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    )

    assert input.created_at != nil
  end

  def test_create_output_via_client
    output = client.create_output(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    )

    assert output.created_at != nil
  end

  def test_create_encoding_profile_via_client
    encoding_profile = client.create_encoding_profile(
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

  def test_create_job_via_client
    job = client.create_job(
      input_id: 1,
      output_id: 1,
      encoding_profile_id: 1,
      manifest_types: ["mpd", "m3u8"]
    )

    assert job.created_at != nil
  end

  def test_transfer_job_via_client
    skip("Resolve mock api issue")

    transfer = client.transfer_job(
      job_id: 1,
      output_id: 1
    )

    assert transfer.created_at != nil
  end
end
