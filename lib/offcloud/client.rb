# frozen_string_literal: true

require 'httparty'

module Offcloud
  class Client
    class RequestError < StandardError; end
    class AuthnError < RequestError; end

    class << self
      def url_for(server, request_id, filename)
        "https://#{server}.offcloud.com/cloud/download/#{request_id}/#{filename}"
      end
    end

    def initialize(logger = nil)
      @logger = logger || Rails&.logger
    end

    def add(url)
      resp = post("cloud", body: { url: url })
      raise_error(resp) if error?(resp)

      File.new(resp.parsed_response)
    end

    def remove(request_id)
      get("cloud/remove/#{request_id }", api: false)
    end

    def fetch
      History.new(get("cloud/history").parsed_response)
    end

    def status(request_id)
      resp = post("cloud/status", body: { requestId: request_id }).parsed_response["status"]

      resp.present? ? File.new(resp) : nil
    end

    def files(request_id)
      resp = get("cloud/explore/#{request_id}")
      raise_error(resp) if error?(resp)

      urlencode_filenames(resp.parsed_response.reject { |file| file.ends_with?("/") })
    end

    def download(url, dest, &block)
      mkdirs(dest)

      store(url, dest, &block)
    end

    private

    def urlencode_filenames(urls)
      urls.map do |url|
        parts = url.rpartition(/\/\d+\//)
        parts[-1] = CGI.escape(parts[-1])

        parts.join
      end
    end

    def raise_error(resp)
      raise AuthnError, "Authentication failed" if resp.to_s.match?(/Login to your account/)

      raise RequestError, resp.parsed_response
    end

    def error?(resp)
      return true unless resp.ok?
      return true if resp.to_s.match?(/Login to your account/)

      resp.parsed_response.is_a?(Hash) && resp.parsed_response["error"].present?
    end

    def store(url, dest_path)
      args = { query: { key: api_key }, stream_body: true }

      ::File.open(dest_path, "w") do |file|
        file.binmode
        amount_downloaded = 0
        resp = HTTParty.get(url, **args) do |fragment|
          file.write(fragment)
          amount_downloaded += fragment.size
          yield(amount_downloaded) if block_given?
        end

        log_request("GET", url, resp, **args)

        resp
      end
    end

    def get(path, query: {}, headers: {}, api: true)
      url = api ? api_url : offcloud_url

      request(
        :get,
        "#{url}/#{path}",
        query: query.merge(key: api_key),
        headers: headers.merge(get_headers)
      )
    end

    def post(path, query: {}, body: {}, headers: {})
      HTTParty.post(
        "#{api_url}/#{path}",
        query: query.merge(key: api_key),
        body: body.to_json,
        headers: headers.merge(post_headers)
      )
    end

    def request(method, path, **args)
      resp = HTTParty.public_send(:get, path, **args)

      log_request(method, path, resp, **args)

      resp
    end

    def log_request(method, path, resp, **args)
      args = args.dup
      query = args.delete(:query).dup
      query[:key] = "XXX" if query[:key]
      query_str = query ? "?#{query.to_query}" : ""

      @logger&.info("#{method.upcase} #{path}#{query_str} #{args.to_json} #{resp.code}")
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

    def get_headers
      { "Cache-Control" => "no-cache" }
    end

    def post_headers
      { "Content-Type" => "application/json" }
    end
  end
end
