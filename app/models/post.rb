class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  attr_accessible :title, :url

  validates :user_id, :presence => true
end
