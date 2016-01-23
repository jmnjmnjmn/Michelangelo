class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_secure_password

  has_many :friendships
  has_many :users, through: :friendships
  has_many :comments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :unlikes, dependent: :destroy

  has_attached_file :image, :styles => { :small => "150x150", :regular => "300x300" },
                    :default_url => 'missing.png'

                    # #for production uploads
                    # :storage=> :s3,
                    # :s3_credentials => "#{Rails.root}/config/aws.yml",
                    # :path => "/profile/:id/:style:extension"
                    
                    # #for development uploads:
                    # :url => "/assets/users/:id/:style/:basename.:extension",
                    # :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']


  after_destroy :ensure_an_admin_remains
  

  def friends
    friender_friends_ids = "SELECT friender_id FROM friendships
                            WHERE friended_id = :user_id AND accepted = 1"
    friended_friends_ids = "SELECT friended_id FROM friendships
                            WHERE friender_id = :user_id AND accepted = 1"

    User.where("id IN (#{friender_friends_ids}) OR
          id IN (#{friended_friends_ids})", user_id: self.id)
      
  end

  # Only display the sharing contents of the user and his friends
  def discover_musics
    valid_ids = self.friends.map {|friend| friend.id}
    valid_ids.push(self.id)
    Music.where(:uid => valid_ids).order("created_at DESC")
  end

  def music_lastupdate
    valid_ids = self.friends.map {|friend| friend.id}
    valid_ids.push(self.id)
    Music.where(:uid => valid_ids).maximum(:updated_at)
  end

  def timeline_lastupdate
    Music.where(:uid => self.id).maximum(:updated_at)
  end  

  # Only display the sharing contents of the user and his friends
  def discover_audios
    valid_ids = self.friends.map {|friend| friend.id}
    valid_ids.push(self.id)
    Audio.where(:uid => valid_ids).order("created_at DESC")
  end  

  def audio_lastupdate
    valid_ids = self.friends.map {|friend| friend.id}
    valid_ids.push(self.id)
    Audio.where(:uid => valid_ids).maximum(:updated_at)
  end  

  def audiotimeline_lastupdate
    Audio.where(:uid => self.id).maximum(:updated_at)
  end  

  def requests_from
    # frienders_ids = "SELECT friender_id FROM friendships 
    #                  WHERE friended_id = :user_id AND accepted = false"
    frienders_ids = "SELECT friender_id FROM friendships 
                     WHERE friended_id = :user_id AND accepted = 0"

    User.where("id IN (#{frienders_ids})", user_id: self.id)
  end

  def friend_request(friended)
    friender_id = self.id 
    # friended_id = params[:id] # this is the id of the user you want to become friend with
    friendship = Friendship.create(friender_id: friender_id, friended_id: friended.id, accepted: 0)
  end

  def check_friendship(friend_id)
    result1 = Friendship.where(friender_id: self.id, friended_id: friend_id, accepted: 1 ) 
    result2 = Friendship.where(friender_id: friend_id, friended_id: self.id, accepted: 1 )
    (result1.any? || result2.any?)
  end

  def friend_request_accept(friender)
    # accepting a friend request is done by the recipient of the friend request.
    # thus the current user is identified by friended_id.
    friendship = Friendship.where(friended_id: self.id,  friender_id: friender.id).first
    friendship.update_attributes(accepted: 1)
  end

  def friend_request_reject(friender)
    friendship = Friendship.where(friended_id: self.id,  friender_id: friender.id).first
    friendship.destroy
  end

  def like(post, liketype)

    like = Like.new(post_id: post.id, user_id: self.id, liketype: liketype)
    like.save

  end

  def already_like?(post_id)
    self.likes.find(:all, :conditions => ['post_id = ?', post_id]).size > 0
  end

def self.search(user_name)
    # if user_name
    #     user_name.downcase!
    #     User.where('LOWER(name) LIKE ?', "%#{user_name}%")
    # else
    #     all
    # end
    User.where("name like ?", "%#{user_name}%").order("created_at DESC")
end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end     
end
