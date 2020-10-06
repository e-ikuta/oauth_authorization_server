class ApprovedScope < ApplicationRecord
  belongs_to :code_credential
  belongs_to :scope
end
