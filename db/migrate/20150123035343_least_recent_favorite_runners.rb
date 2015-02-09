class LeastRecentFavoriteRunners < ActiveRecord::Migration
  def change
    create_table :least_recent_favorite_runners do |t|
      t.integer :max_id, limit: 8
      t.boolean :complete, default: false
      t.belongs_to :user, index: true
    end
  end
end
