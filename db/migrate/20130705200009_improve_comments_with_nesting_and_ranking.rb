class ImproveCommentsWithNestingAndRanking < ActiveRecord::Migration
  def change
    add_column :comments, :short_id,          :string, :limit => 10, :default => "", :null => false
    add_column :comments, :parent_comment_id, :integer
    add_column :comments, :thread_id,         :integer
    add_column :comments, :confidence,        :decimal, :default => 0.0,             :null => false

    add_index :comments, :confidence
    add_index :comments, :short_id, :unique => true
    add_index :comments, [:post_id, :short_id]
    add_index :comments, :thread_id
  end
end
