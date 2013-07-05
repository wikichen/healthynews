class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :vote,    :limit => 1, :null => false
      t.integer :user_id,              :null => false
      t.integer :post_id,              :null => false
      t.integer :comment_id

      t.timestamps
    end
  end
end
