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
      json = hash.inject({}) do |acc, props|
        acc[camelize(props.first.to_s, false)] = props.last
        acc
      end

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

      json.inject({}) do |acc, props|
        acc[underscore(props.first.to_s).to_sym] = props.last
        acc
      end
    rescue => e
      nil
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

