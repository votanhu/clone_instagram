class CommentController < ApplicationController
  def add
  	comment = Comment.new
  	comment.id_photo = params['id_photo']
  	comment.id_user  = session[:logged_user_id]
  	comment.message  = params['message']
  	comment.save
  	comment.message.scan(/\#[[:alnum:]]+/).each do |tag|
  		hashtag = Hashtag.new
  		hashtag.tag = tag
  		hashtag.save

  		photo_hashtag = PhotoHashtag.new
  		photo_hashtag.id_photo = params['id_photo']
  		photo_hashtag.id_tag   = hashtag.id
  		photo_hashtag.save
  	end

  	render html: "<li><span class='author-info'>#{User.find(session[:logged_user_id]).username}</span><span class='message'>#{params['message']}</span></li>".html_safe
  end
end
