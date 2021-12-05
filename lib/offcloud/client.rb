# frozen_string_literal: true

require 'httparty'

require 'offcloud/history'

module Offcloud
  class Client
    def add(url)
      post("#{api_url}/cloud", body: { url: url })
    end

    def fetch
      History.new(get("cloud/history").parsed_response)
    end

    def explore(request_id)
      get("cloud/explore/#{request_id}")
    end

    def download(request_id, filename)
      store("cloud/download/#{request_id}/#{filename}", Rails.root.join("tmp", filename))
    end

    private

    def store(url, dest_path)
      ::File.open(dest_path, "w") do |file|
        file.binmode
        HTTParty.get("#{api_url}", query: {key: api_key}, stream_body: true) do |fragment|
          file.write(fragment)
        end
      end
    end

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
