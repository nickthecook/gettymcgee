# frozen_string_literal: true

require 'httparty'

module Offcloud
  class Client
    def add(url)
      post("#{api_url}/cloud", body: { url: url })
    end

    def fetch
      History.new(get("cloud/history").parsed_response)
    end

    def files(request_id)
      explore = get("cloud/explore/#{request_id}")
      return nil unless explore.ok?

      explore.parsed_response.reject { |file| file.ends_with?("/") }.map do |url|
        url.split("#{request_id}/").last
      end
    end

    def list(request_id)
      get("cloud/list/#{request_id}")
    end

    def download(request_id, server, filename, dest)
      puts "DEST: #{dest}"
      mkdirs(dest)

      url = "#{server_url(server)}/cloud/download/#{request_id}/#{CGI.escape(filename)}"
      store(url, dest)
    end

    private

    def store(url, dest_path)
      ::File.open(dest_path, "w") do |file|
        file.binmode
        HTTParty.get(url, query: {key: api_key}, stream_body: true) do |fragment|
          file.write(fragment)
        end
      end
    end

    def get(path, query: {})
      HTTParty.get("#{api_url}/#{path}", query: query.merge(key: api_key), headers: { "Cache-Control" => "no-cache" })
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
      "https://offcloud.com/api"
    end

    def offcloud_url
      "https://offcloud.com"
    end

    def server_url(server)
      "https://#{server}.offcloud.com"
    end

    def mkdirs(path)
      dir = ::File.dirname(path)

      FileUtils.mkdir_p(dir)
    end
  end
end
