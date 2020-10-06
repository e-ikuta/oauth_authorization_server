class CreateCodeCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :code_credentials do |t|
      t.references :client, null: false, foreign_key: true
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
