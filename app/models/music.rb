class Music < ActiveRecord::Base
  
  acts_as_taggable
  

  has_many   :comments, :foreign_key => :post_id, dependent: :destroy
  has_many   :likes, :foreign_key => :post_id, dependent: :destroy
  # has_many   :unlikes, :foreign_key => :post_id, dependent: :destroy

  # regex = /http:\/\/music.163.com\/\#\/song\?id\=(.*)/
  regex = /http:\/\/music.163.com\/outchain\/player\?type=2\&id=(.*)\&auto=0\&height=66|http:\/\/music.163.com\/outchain\/player\?type=0\&id=(.*)\&auto=0\&height=430/
  # regex2 = /http:\/\/music.163.com\/outchain\/player?type=0&id=(.*)&auto=0&height=430/

  validates :link, presence: true,
                  format: { :with => regex }
  # validates :comment, presence: true

  validates :uid, presence: true

  def user
  	User.find(self.uid)
  end


 def allcomments
    Comment.where(post_id: self.id, commenttype: 0 ).order("created_at DESC")
  end


  def top3comments
    Comment.where(post_id: self.id, commenttype: 0).order("created_at DESC").limit(3)
  end


  def likecount
  	Like.where(post_id: self.id, liketype: 0).count
  end

  # def unlikecount
  #   Unlike.where(post_id: self.id).count
  # end


end



