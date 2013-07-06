class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment, :class_name => "Comment"
  has_many :votes, :dependent => :delete_all

  attr_accessible :comment

  attr_accessor :parent_comment_short_id,
                :current_vote,
                :indent_level,
                :highlighted

  before_create :assign_short_id_and_upvote, :assign_initial_confidence
  after_create  :assign_votes

  validate do
    self.comment.to_s.strip == "" && errors.add(:comment, "cannot be blank.")
    self.user_id.blank? && errors.add(:user_id, "cannot be blank.")
    self.post_id.blank? && errors.add(:post_id, "cannot be blank.")
  end

  def assign_short_id_and_upvote
    self.short_id = ShortId.new(self.class).generate
    self.upvotes = 1
  end

  def assign_votes
    Vote.vote_thusly_on_post_or_comment_for_user_because(1, self.post_id,
      self.id, self.user.id, nil, false)
  end

  def assign_initial_confidence
    self.confidence = self.calculated_confidence
  end

  def score
    self.upvotes - self.downvotes
  end

  def give_upvote_or_downvote_and_recalculate_confidence!(upvote, downvote)
    self.upvotes += upvote.to_i
    self.downvotes += downvote.to_i

    Comment.connection.execute("UPDATE #{Comment.table_name} SET " <<
      "upvotes = COALESCE(upvotes, 0) + #{upvote.to_i}, " <<
      "downvotes = COALESCE(downvotes, 0) + #{downvote.to_i}, " <<
      "confidence = '#{self.calculated_confidence}' WHERE id = " <<
      "#{self.id.to_i}")
  end

  # http://amix.dk/blog/post/19588
  # https://github.com/reddit/reddit/blob/master/r2/r2/lib/db/_sorts.pyx
  def calculated_confidence
    n = (upvotes + downvotes).to_f
    if n == 0.0
      return 0
    end

    z = 1.2815515 # confidence: 80%, 1.0 = 85%, 1.6 = 95%
    p = upvotes.to_f / n

    left = p + (1 / ((2.0 * n) * z * z))
    right = z * Math.sqrt((p * ((1.0 - p) / n)) + (z * (z / (4.0 * n * n))))
    under = 1.0 + ((1.0 / n) * z * z)

    return (left - right) / under
  end

  def self.ordered_for_post_or_thread_for_user(post_id, thread_id, user)
    parents = {}

    if thread_id
      cs = [ "thread_id = ?", thread_id ]
    else
      cs = [ "post_id = ?", post_id ]
    end

    Comment.find(:all,
                 :conditions => cs,
                 :order => "confidence DESC", # change this to sort by confidence later
                 :include => :user).each do |c|
      (parents[c.parent_comment_id.to_i] ||= []).push c
    end

    # top-down list of comments, regardless of indent level
    ordered = []

    recursor = lambda{|comment, level|
      if comment
        comment.indent_level = level
        ordered.push comment
      end

      # for each comment that's a child of it, recurse
      (parents[comment ? comment.id : 0] || []).each do |child|
        recursor.call(child, level + 1)
      end
    }
    recursor.call(nil, 0)

    ordered

    # TODO: take care of cases with deleted comments
  end



end
