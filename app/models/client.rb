class Client < ApplicationRecord
  validates :client_id, presence: true, uniqueness: true
  validates :client_secret, presence: true, uniqueness: true

  has_many :redirect_uris
  has_many :scopes
  has_many :code_credentials
end
