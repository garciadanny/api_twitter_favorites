class LastFetchedFavorites < ActiveRecord::Migration
  def change
    create_table :last_fetched_favorites do |t|
      t.integer :favorite_id
      t.belongs_to :user, index: true
      t.boolean :last_favorite, default: false
    end
  end
end
