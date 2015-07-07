class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	validates :followed_id, presence: true
	validates :follower_id, presence: true
	has_many :following, through: :active_relationships, source: :followed
end
