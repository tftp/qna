class CreateBadges < ActiveRecord::Migration[6.0]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.belongs_to :badgeable, polymorphic: true

      t.timestamps
    end
  end
end
