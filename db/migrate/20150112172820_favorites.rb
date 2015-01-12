class Favorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :user, index: true
      t.string :twitter_id
      t.text :text
    end
  end
end
