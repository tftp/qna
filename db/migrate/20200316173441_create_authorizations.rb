class CreateAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :authorizations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string   :confirmation_token, null: false
      t.datetime :confirmed_at


      t.timestamps
    end

    add_index :authorizations, [:provider, :uid]
  end
end
