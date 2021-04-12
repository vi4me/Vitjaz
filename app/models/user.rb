class User < ApplicationRecord
  has_many :posts
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 def username
   self.email.split(/@/).first.capitalize
 end
end
