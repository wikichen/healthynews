class Post < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  has_many   :votes

  attr_accessible :title, :url, :user_id

  attr_accessor :vote

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

  def title=(t)
    # change unicode whitespace characters into real spaces
    self[:title] = t.strip
  end

  def title_as_url
    u = self.title.downcase.gsub(/[^a-z0-9_-]/, "_")
    while u.match(/__/)
      u.gsub!("__", "_")
    end
    u.gsub(/^_+/, "").gsub(/_+$/, "")
  end

  def url=(u)
    # strip out stupid google analytics parameters
    if u && (m = u.match(/\A([^\?]+)\?(.+)\z/))
      params = m[2].split("&")
      params.reject!{|p|
        p.match(/^utm_(source|medium|campaign|term|content)=/) }

      u = m[1] << (params.any?? "?" << params.join("&") : "")
    end

    self[:url] = u
  end

  def url_or_comments_url
    self.url.blank? ? self.comments_url : self.url
  end

  def comments_url
    "#{short_id_url}/#{self.title_as_url}"
  end

  def short_id_url
    Rails.application.routes.url_helpers.root_url + "p/#{self.short_id}"
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
