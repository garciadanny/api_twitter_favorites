class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :twitter_id
      t.string :twitter_handle
      t.string :access_token
      t.string :access_token_secret
      t.integer :initial_favorites_count
      t.integer :last_fetched_favorite_id
    end

    add_index :users, :twitter_id
  end
end
