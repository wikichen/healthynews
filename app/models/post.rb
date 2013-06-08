class Post < ActiveRecord::Base
  belongs_to :user

  attr_accessible :title, :url

  validates :user_id, :presence => true
end
