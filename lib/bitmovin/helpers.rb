# frozen_string_literal: true

require 'json'

module Bitmovin
  module Helpers

    S3_BUCKET_SUBDOMAIN_REGEX = /^https?:\/\/(.*)\.s3/.freeze
    S3_BUCKET_IN_URL_REGEX = /^https?:\/\/s3\.amazonaws\.com\/([\w\-\_]+)\//.freeze

    S3_OBJECT_KEY_SUBDOMAIN_REGEX = /^https?:\/\/(?:.*)\.s3\.amazonaws\.com\/(.*)/.freeze
    S3_OBJECT_KEY_IN_URL_REGEX = /^https?:\/\/s3\.amazonaws\.com\/[\w\-\_]+\/(.*)/.freeze

    ##
    # Converting passed hash to be acceptable by bitmivin api
    #
    # @param hash [Hash] the hash to be converted
    #
    # @return [String] valid json string
    #
    def prepare_request_json(hash)
      json = deep_camelize_keys(hash)
      JSON.generate(json)
    end

    ##
    # Converting bitmovin api response json to ruby hash
    #
    # @param json [String] json string with camelcased keys
    #
    # @return [Hash] parsed api response with snakecased keys
    #
    def prepare_response_json(json)
      json = JSON.parse json

      if json.is_a?(Hash)
        deep_underscore_keys json
      elsif json.is_a?(Array)
        json.map { |ji| deep_underscore_keys(ji) }
      end
    end

    ##
    # Converts hash keys to string in camelCase
    # @param subject [Hash] Hash to be converted
    # @param first_letter_in_uppercase [Boolean] Is first letter should be uppercased
    #
    # @return [Hash] converted hash with stringified keys in camelCase
    def deep_camelize_keys(subject, first_letter_in_uppercase = false)
      init_value = Hash.new
      subject.inject init_value do |acc, props|
        acc[camelize(props.first.to_s, first_letter_in_uppercase).to_sym] = case props.last
          when Hash then deep_camelize_keys(props.last, first_letter_in_uppercase)
          when Array then props.last.map { |i| i.is_a?(Hash) ? deep_camelize_keys(i, first_letter_in_uppercase) : i }
          else props.last
          end
        acc
      end
    end

    ##
    # Converts hash keys to symbols in snake_case
    # @param subject [Hash] Hash to be converted
    #
    # @return [Hash] converted hash with symbolized keys in snake_case
    def deep_underscore_keys(subject)
      init_value = subject.class.new if subject.is_a?(Hash) || subject.is_a?(Array)
      subject.inject init_value do |acc, props|
        acc[underscore(props.first.to_s).to_sym] = case props.last
          when Hash then deep_underscore_keys(props.last)
          when Array then props.last.map { |i| i.is_a?(Hash) ? deep_underscore_keys(i) : i }
          else props.last
          end
        acc
      end
    end


    ##
    # Extracts AWS S3 bucket name from url
    #
    # @param url [String] url to AWS S3 file
    #
    # @return [String] name of bucket
    #
    def extract_bucket(url)
      unescaped = URI.unescape(url)

      bucket = unescaped.match(S3_BUCKET_SUBDOMAIN_REGEX)[1] rescue nil
      bucket ||= unescaped.match(S3_BUCKET_IN_URL_REGEX)[1] rescue nil

      bucket
    end

    ##
    # Extracts AWS S3 file name from url
    #
    # @param url [String] url to AWS S3 file
    #
    # @return [String] name of file with containing folders
    #
    def extract_object_key(url)
      unescaped = URI.unescape(url)

      file = unescaped.match(S3_OBJECT_KEY_SUBDOMAIN_REGEX)[1] rescue nil
      file ||= unescaped.match(S3_OBJECT_KEY_IN_URL_REGEX)[1] rescue nil

      file
    end

    protected

    def headers
      @headers ||= {
        'Content-Type' => "application/json",
        'bitcodin-api-version' => 'v1',
        'bitcodin-api-key' => Bitmovin.api_key
      }
    end


    def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        lower_case_and_underscored_word[0] + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end

    def underscore(str)
      str.gsub(/[A-Z\s]/) { "_#{$&.downcase}" }
    end

  end
end

