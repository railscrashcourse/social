class User < ActiveRecord::Base
  has_many :subscriptions, foreign_key: :follower_id,
                           dependent: :destroy
  has_many :leaders, through: :subscriptions

  has_many :reverse_subscriptions, foreign_key: :leader_id,
                                   class_name: 'Subscription',
                                   dependent: :destroy
  has_many :followers, through: :reverse_subscriptions

  has_many :posts, dependent: :destroy
  has_many :text_posts, dependent: :destroy
  has_many :image_posts, dependent: :destroy

  has_many :comments

  has_secure_password

  validates :email, presence: true, uniqueness: true

  def following?(leader)
    leaders.include? leader
  end

  def follow!(leader)
    if leader != self && !following?(leader)
      leaders << leader
    end
  end

  def timeline_user_ids
    leader_ids + [id]
  end
end
