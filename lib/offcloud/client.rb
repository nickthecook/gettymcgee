# frozen_string_literal: true

require 'httparty'

module Offcloud
  class Client
    def add(url)
      post("#{api_url}/cloud", url: url)
    end

    private

    def request(method, path, **params)
      response = HTTParty.public_send(method, path, query: params.merge(key: api_key))

      puts response.request.last_uri.to_s

      response
    end

    def get(path, **params)
      request(:get, path, **params)
    end

    def post(path, **params)
      request(:post, path, **params)
    end

    def api_key
      ENV["OFFCLOUD_API_KEY"]
    end

    def api_url
      ENV["OFFCLOUD_API_URL"]
    end
  end
end
