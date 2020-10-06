class Scope < ApplicationRecord
  validates :name, presence: true

  belongs_to :client
  has_many :approved_scopes
end
