class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :login,
                  :password, :password_confirmation, :remember_me

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username, presence: true,
                       length: { maximum: 20 },
                       uniqueness: { case_sensitive: false }
  validates :email,    presence: true,
                       uniqueness: { case_sensitive: false }

  protected

   def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:login)
     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
   end
end
