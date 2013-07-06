class AddHotnessToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hotness, :decimal, :precision => 20, :scale => 10, :default => 0.0, :null => false

    add_index :posts, :hotness
  end
end
