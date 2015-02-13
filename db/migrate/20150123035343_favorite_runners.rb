class FavoriteRunners < ActiveRecord::Migration
  def change
    create_table :favorite_runners do |t|
      t.integer :max_id, limit: 8
      t.boolean :complete, default: false
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
