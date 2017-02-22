# frozen_string_literal: true

require File.expand_path('../helpers', __FILE__)

module Bitmovin
  # Represents a bitmovin transfer Job
  # @see https://bitmovin.com/encoding-documentation/encoder-api-reference-documentation/#/reference/jobs Bitmovin Job docs
  class TransferJob
    include Bitmovin::Helpers

    ATTRIBUTES = %i{
      id
      job_id
      output_id
      status
      progress
      created_at
      output_name
    }

    ATTRIBUTES.each do |_attr|
      define_method _attr do
        @details[_attr]
      end

      define_method :"#{_attr}=" do |value|
        @details[_attr] = value
      end
    end

    #
    # @option params job_id [Integer] Job-ID
    # @option params output_id [Integer] Output-ID
    #
    def initialize(params={})
      @details = params
    end

    #
    # @option params job_id [Integer] Job-ID
    # @option params output_id [Integer] Output-ID
    #
    # @return [Bitmovin::TransferJob] Bitmovin Transfer Job details
    #
    def self.create(params={})
      new(params).create
    end

    ##
    # Creates a new bitmovin transfer job with params given within initialization
    # @return [Bitmovin::TransferJob] Bitmovin Transfer Job details
    def create
      make_create_request
    end

    ##
    # Get bitmovin encoding job details
    # @param reload Force reload from server
    # @return [Hash] Bitmovin Job details
    def details(reload = false)
      return @details
    end

    class << self
      include Bitmovin::Helpers

      ##
      # Get list of available transfers related to job
      # @return [Array<Bitmovin::TransferJob>] array of transfer jobs
      #
      def list(reload = false)
        return @list if @list && !relaod

        get = Net::HTTP::Get.new "/api/jobs/#{ @details[:job_id] }/transfers", initheaders = headers

        response = Bitmovin.http.request get

        json = prepare_response_json(response.body)

        @list = json[:jobs].map { |p| Bitmovin::TransferJob.new(p) }

        @list
      end
    end

    private

    def make_create_request
      payload = prepare_request_json @details

      post = Net::HTTP::Post.new "/api/job/transfer", initheaders = headers
      post.body = payload

      response = Bitmovin.http.request post
      puts response

      @details = prepare_response_json response.body
      self
    end
  end
end
