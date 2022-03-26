# frozen_string_literal: true

class CleanApiCallsService
  def execute    
    ApiCall.where("created_at < ?", 6.hours.ago).destroy_all
  end
end
