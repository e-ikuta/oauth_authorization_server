class CreateApprovedScopes < ActiveRecord::Migration[6.0]
  def change
    create_table :approved_scopes do |t|
      t.references :code_credential, foreign_key: true
      t.references :scope, foreign_key: true

      t.timestamps
    end
  end
end
