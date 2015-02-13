class Favorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :user, index: true
      t.integer :twitter_id, limit: 8
      t.text :text

      t.timestamps
    end
  end
end
