module UsersHelper

	def cache_key_for_searchedUser_table(searchedUser)
		if searchedUser
	      lastUpdate = User.search(searchedUser).maximum(:updated_at)
	      "searchedUser-table-#{searchedUser}-#{lastUpdate}"
	    else
	      lastUpdate = User.maximum(:updated_at)
	      "searchedUser-table-0-#{User.maximum(:created_at)}-#{lastUpdate}"
	    end  

	end

	def cache_key_for_searchedUser_row(searchedUser)
	    "searchedUser-#{searchedUser.id}-#{searchedUser.updated_at}"
	end


	def cache_key_for_timeline_table(user)
	    "music-table-#{user.id}-#{user.timeline_lastupdate}-#{user.updated_at}"
	end

	def cache_key_for_timeline_row(music)
	    "music-#{music.id}-#{music.updated_at}-#{music.likecount}"
	end	


	def cache_key_for_audiotimeline_table(user)
	    "audio-table-#{user.id}-#{user.audiotimeline_lastupdate}-#{user.updated_at}"
	end

	def cache_key_for_audiotimeline_row(audio)
	    "audio-#{audio.id}-#{audio.updated_at}-#{audio.audiolikecount}"
	end	

end
