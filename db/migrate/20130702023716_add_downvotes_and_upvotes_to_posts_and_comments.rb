class AddDownvotesAndUpvotesToPostsAndComments < ActiveRecord::Migration
  def up
    add_column :posts, :upvotes, :integer,       :default => 0, :null => false
    add_column :posts, :downvotes, :integer,     :default => 0, :null => false
    add_column :comments, :upvotes, :integer,    :default => 0, :null => false
    add_column :comments, :downvotes, :integer,  :default => 0, :null => false

    Post.all.each do |p|
      p.give_upvote_or_downvote_and_recalculate_hotness!(0, 0)
    end
  end

  def down
  end
end
