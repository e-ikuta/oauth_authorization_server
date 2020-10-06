class RedirectUri < ApplicationRecord
  validates :uri, presence: true

  belongs_to :client
end
