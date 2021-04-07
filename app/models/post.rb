class Post < ApplicationRecord
  validates :title, :content, presence: true
  has_rich_text :content
  belongs_to :user
  acts_as_votable
  validates :title, length: { maximum: 70 }
  validates :content, length: { maximum: 10000 }
	
end
