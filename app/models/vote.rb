class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :post_id, :user_id, :vote

  validates :user_id, :uniqueness => { :scope => :post_id }

  def self.vote_thusly_on_post_or_comment_for_user_because(vote, post_id,
    comment_id, user_id, reason, update_counters = true)

    v = Vote.find_or_initialize_by_user_id_and_post_id_and_comment_id(user_id,
      post_id, comment_id)

    if !v.new_record? && v.vote == vote
      return
    end

    upvote = 0
    downvote = 0

    Vote.transaction do
      # unvote
      if vote == 0
        if !v.new_record?
          if v.vote == -1
            downvote = -1
          else
            upvote = -1
          end
        end

        v.destroy

      # new vote or change vote
      else
        if v.new_record?
          if vote == -1
            downvote = 1
          else
            upvote = 1
          end
        elsif v.vote == -1
          # changing downvote to upvote
          downvote = -1
          upvote = 1
        elsif v.vote == 1
          # changing upvote to downvote
          upvote = -1
          downvote = 1
        end

        v.vote = vote
        v.save!
      end

      if update_counters && (downvote != 0 || upvote != 0)
        # vote for comment
        if v.comment_id
          # increase karma for user

        # vote for post
        else
          p = Post.find(v.post_id)
          # increase karma for user

          p.give_upvote_or_downvote_and_recalculate_hotness!(upvote, downvote)
        end
      end
    end
  end
end
