class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates :email, presence: true, length: {minimum: 2}
  validates :password, presence: true, length: {minimum: 7}

  has_secure_password
end
