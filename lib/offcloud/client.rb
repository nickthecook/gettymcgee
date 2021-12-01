# frozen_string_literal: true

require 'httparty'

module Offcloud
  class Client
    def add(url)
      post("#{api_url}/cloud", body: { url: url })
    end

    def fetch
      get("cloud/history")
    end

    private

    def get(path, query: {}, body: {})
      HTTParty.get("#{api_url}/#{path}", query: query.merge(key: api_key))
    end

    def post(path, query: {}, body: {})
      response = HTTParty.post(path, query: query.merge(key: api_key), body: body.to_json)
      puts response.request.last_uri.to_s
      pp response.inspect
    end

    def api_key
      ENV["OFFCLOUD_API_KEY"]
    end

    def api_url
      ENV["OFFCLOUD_API_URL"]
    end
  end
end
