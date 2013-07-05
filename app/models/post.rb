class Post < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  has_many   :votes

  attr_accessible :title, :url, :user_id

  validates :user_id, :presence => true
  validates :title, :presence => true
  validates :url, :presence => true,
                    uniqueness: { case_sensitive: false }

  before_create :assign_short_id
  before_update :recalculate_hotness!

  def assign_short_id
    self.short_id = ShortId.new(self.class).generate
  end

  def domain
    if self.url.blank?
      nil
    else
      pu = URI.parse(self.url)
      pu.host.gsub(/^www\d*\./, "")
    end
  end

  def score
    upvotes - downvotes
  end

  def self.recalculate_all_hotnesses!
    Post.all.each do |s|
      s.recalculate_hotness!
    end
  end

  def recalculate_hotness!
    Post.connection.execute("UPDATE #{Post.table_name} SET " <<
      "hotness = '#{self.calculated_hotness}' WHERE id = #{self.id.to_i}")
  end

  def calculated_hotness
    order = Math.log([ score.abs, 1 ].max, 10)
    if score > 0
      sign = 1
    elsif score < 0
      sign = -1
    else
      sign = 0
    end

    # TODO: as the site grows, shrink this down to 12 or so.
    window = 60 * 60 * 48

    return -(order + (sign * (self.created_at.to_f / window))).round(7)
  end

  def give_upvote_or_downvote_and_recalculate_hotness!(upvote, downvote)
    self.upvotes += upvote.to_i
    self.downvotes += downvote.to_i

    Post.connection.execute("UPDATE #{Post.table_name} SET " <<
      "upvotes = COALESCE(upvotes, 0) + #{upvote.to_i}, " <<
      "downvotes = COALESCE(downvotes, 0) + #{downvote.to_i}, " <<
      "hotness = '#{self.calculated_hotness}' WHERE id = #{self.id.to_i}")
  end



end
