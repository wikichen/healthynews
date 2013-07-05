class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title,                 :default => "", :null => false
      t.string :url,                   :default => ""
      t.string :short_id, :limit => 6, :default => "", :null => false
      t.references :user

      t.timestamps
    end
    add_index :posts, :user_id
  end
end