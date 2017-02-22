require 'minitest/autorun'
require 'test_helper'
require 'bitmovin'

class TransferJobTest < MiniTest::Test
  extend Minitest::Spec::DSL

  def setup
    Bitmovin.api_key = "somefuncyapikey"
  end

  let(:input) do
    Bitmovin::Input.create(
      bucket: "bucket-name",
      object_key: "/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    )
  end

  let(:output) do
    Bitmovin::Output.create(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    )
  end

  let(:encoding_profile) do
    Bitmovin::EncodingProfile.create(
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
  end

  let(:job) do
    Bitmovin::Job.create(
      input_id: input.input_id,
      output_id: output.output_id,
      encoding_profile: encoding_profile.encoding_profile_id
    )
  end

  def test_creation_of_transfer_job
    skip "Figure out 'Not found' mock API response"

    transfer_job = Bitmovin::TransferJob.create(
      job_id: job.job_id,
      output_id: output.output_id
    )

    assert transfer_job.created_at != nil
  end
end
