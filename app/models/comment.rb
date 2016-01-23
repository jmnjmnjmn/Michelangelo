class Comment < ActiveRecord::Base
  belongs_to :music
  belongs_to :user
  belongs_to :audio
 
  validates :content,      presence: true
  validates :post_id,      presence: true
  validates :user_id, presence: true

  def user
  	User.find(self.user_id)
  end

end
