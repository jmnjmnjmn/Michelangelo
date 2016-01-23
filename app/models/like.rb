class Like < ActiveRecord::Base
  belongs_to :music
  belongs_to :user
  belongs_to :audio

  
  validates :post_id,      presence: true
  validates :user_id, presence: true

  before_save :check_duplicate

  def check_duplicate
    (Like.where(  post_id: self.post_id, 
                  user_id: self.user_id,
                  liketype: self.liketype).exists?) ? false : true
  end

end
