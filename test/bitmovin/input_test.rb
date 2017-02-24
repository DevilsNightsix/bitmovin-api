require 'minitest/autorun'
require 'test_helper'
require 'bitmovin/input'

class InputTest < MiniTest::Test

  def setup
    Bitmovin.api_key = "somefuncyapikey"
  end

  def test_input_instantiating_with_url
    input = Bitmovin::Input.new("https://bucket-name.s3.amazonaws.com/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    )

    assert_equal "bucket-name", input.details[:bucket]
  end

  def test_input_instantiating_with_options_hash_only
    input = Bitmovin::Input.new(
      bucket: "bucket-name",
      object_key: "/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    )

    assert_equal "bucket-name", input.details[:bucket]
  end

  def test_create_method_should_create_input_with_given_params
    input = Bitmovin::Input.create(
      bucket: "bucket-name",
      object_key: "/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    )

    assert input.details != nil
  end

  def test_get_input_details
    id = Bitmovin::Input.create(
      bucket: "bucket-name",
      object_key: "/path/to/file.txt",
      type: 's3',
      access_key: "awsS3Key",
      secret_key: "awsS3Secret"
    ).details[:input_id]

    input = Bitmovin::Input.new(input_id: id)
    details = input.details

    assert details != nil
  end

  def test_create_raises_error_when_required_parameter_access_key_not_given
    assert_raises Bitmovin::ApiParameterEmptyError, "Is required" do
      Bitmovin::Input.create(
        bucket: "bucket-name",
        object_key: "/path/to/file.txt",
        type: 's3',
        secret_key: "awsS3Secret"
      )
    end
  end

  def test_create_raises_error_when_required_parameter_access_secret_not_given
    assert_raises Bitmovin::ApiParameterEmptyError, "Is required" do
      Bitmovin::Input.create(
        bucket: "bucket-name",
        object_key: "/path/to/file.txt",
        type: 's3',
        access_key: "awsS3Key"
      )
    end
  end

  def test_get_inputs_list
    list = Bitmovin::Input.list

    assert_kind_of Bitmovin::Input, list.sample
  end
end
