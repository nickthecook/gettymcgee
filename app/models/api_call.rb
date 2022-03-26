class ApiCall < ApplicationRecord
  enum service: %i[offcloud]
  enum method: %i[get post put patch del]

  rails_admin do
    list do
      field :service
      field :method
      field :url
      field :status_code
    end
  end
end
