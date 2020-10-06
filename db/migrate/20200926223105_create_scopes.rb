class CreateScopes < ActiveRecord::Migration[6.0]
  def change
    create_table :scopes do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
