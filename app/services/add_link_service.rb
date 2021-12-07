# frozen_string_literal: true

class AddLinkService
  def initialize(link:)
    @link = link
  end

  def execute
    resp = client.add(@link)

    CloudFile.from_object(resp)
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
