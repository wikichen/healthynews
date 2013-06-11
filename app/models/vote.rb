class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :post_id, :user_id, :vote

  validates :user_id, :uniqueness => { :scope => :post_id }
end
