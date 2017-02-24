require 'minitest/autorun'
require 'test_helper'
require 'bitmovin/output'

class OutputTest < MiniTest::Test

  def setup
    Bitmovin.api_key = "somefuncyapikey"
  end

  def test_output_instantiating
    output = Bitmovin::Output.new(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    )

    assert_equal "bucket-name", output.bucket
  end

  def test_output_creation
    output = Bitmovin::Output.create(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    )

    assert output.output_id != nil
  end

  def test_create_of_already_initialized_output
    output = Bitmovin::Output.new(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    )

    output.create

    assert output.output_id != nil
  end

  def test_get_output_details_by_id
    output_id = Bitmovin::Output.new(
      type: 's3',
      access_key: 'awsS3Key',
      secret_key: 'aswS3Secret',
      name: 'file.txt',
      prefix: '/path/to',
      bucket: "bucket-name"
    ).output_id

    output = Bitmovin::Output.new(output_id: output_id)

    assert output.details[:output_id] == output_id
  end

  def test_get_list_of_inputs
    list = Bitmovin::Output.list

    assert_kind_of Bitmovin::Output, list.sample
  end
end
