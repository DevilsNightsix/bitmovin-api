require 'minitest/autorun'
require 'bitmovin/helpers'

class HelpersTest < MiniTest::Test

  include Bitmovin::Helpers

  def test_prepare_request_json
    result = prepare_request_json({ test_key: "test_value" })

    assert_equal "{\"testKey\":\"test_value\"}", result
  end

  def test_prepare_request_json_nested_array
    result = prepare_request_json({
      test_key_outter: [
        { test_key_inner: "test_value" }
      ]
    })

    expectation = "{\"testKeyOutter\":[{\"testKeyInner\":\"test_value\"}]}"

    assert_equal expectation, result
  end

  def test_prepare_request_json_nested_hash
    result = prepare_request_json({
      test_key_outter: {
        test_key_inner: "test_value"
      }
    })

    expectation = "{\"testKeyOutter\":{\"testKeyInner\":\"test_value\"}}"

    assert_equal expectation, result
  end

  def test_prepare_response_json
    result = prepare_response_json("{\"testKey\":\"test_value\"}")

    assert_equal result, { test_key: "test_value" }
  end

  def test_prepare_response_json_nested_array
    result = prepare_response_json("{\"testKeyOutter\": [{ \"testKeyInner\": \"test_value\" }]}")

    expectation = {
      test_key_outter: [
        {
          test_key_inner: "test_value"
        }
      ]
    }
    assert_equal expectation, result
  end

  def test_prepare_response_json_nested_hash
    result = prepare_response_json("{\"testKeyOutter\": { \"testKeyInner\": \"test_value\" } }")

    expectation = {
      test_key_outter: {
        test_key_inner: "test_value"
      }
    }
    assert_equal expectation, result
  end

  def test_extract_bucket_when_bucket_is_subdomain
    url = "https://bucket-name.s3.amazonaws.com/path/to/file.txt"

    assert_equal "bucket-name", extract_bucket(url)
  end

  def test_extract_bucket_when_bucket_is_url
    url = "https://s3.amazonaws.com/bucket-name/path/to/file.txt"

    assert_equal "bucket-name", extract_bucket(url)
  end

  def test_extract_object_key_when_bucket_in_subdomain
    url = "https://bucket-name.s3.amazonaws.com/path/to/file.txt"

    assert_equal "path/to/file.txt", extract_object_key(url)
  end

  def test_extract_object_key_when_bucket_in_url
    url = "https://s3.amazonaws.com/bucket-name/path/to/file.txt"

    assert_equal "path/to/file.txt", extract_object_key(url)
  end
end
