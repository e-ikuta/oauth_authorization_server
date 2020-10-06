class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :client_id, null: false, index: { unique: true }
      t.string :client_secret, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
