class User < ActiveRecord::Base
	has_many :notes
	has_many :collections
	has_many :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :shared_notes
  has_many :being_shared_notes, :class_name => "Shared_note", :foreign_key => "sharedUser"

  def friends
    friends_array = friendships.map{|friendship| friendship.friend if friendship.confirmed}
    friends_array + inverse_friendships.map{|friendship| friendship.user if friendship.confirmed}
    friends_array.compact
  end

  # Users who have yet to confirme friend requests
  def pending_friends
    friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find{|friendship| friendship.user == user}
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end
end
