class MostRecentFavoriteRunners < ActiveRecord::Migration
  def change
    create_table :most_recent_favorite_runners do |t|
      t.integer :since_id, limit: 8
      t.integer :max_id, limit: 8
      t.belongs_to :user, index: true
    end
  end
end
