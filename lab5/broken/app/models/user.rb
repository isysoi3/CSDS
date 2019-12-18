class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates :email, presence: true , length: {minimum: 2}
  validates :password, presence: true, length: {minimum: 2}

  def has_secure_password
    true
  end
end
