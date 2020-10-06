class CodeCredential < ApplicationRecord
  validates :code, presence: true

  belongs_to :client
  has_many :approved_scopes, dependent: :destroy
  has_many :scopes, through: :approved_scopes
end
