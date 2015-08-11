class CommentController < ApplicationController
  def add
  	comment = Comment.new
  	comment.id_photo = params['id_photo']
  	comment.id_user  = session[:logged_user_id]
  	comment.message  = params['message']
  	comment.save
  	comment.message.scan(/\#[[:alnum:]]+/).each do |tag|
  		hashtag = Hashtag.new
  		hashtag.tag = tag[1..-1]
  		hashtag.save

  		photo_hashtag = PhotoHashtag.new
  		photo_hashtag.id_photo = params['id_photo']
  		photo_hashtag.id_tag   = hashtag.id
  		photo_hashtag.save
  	end

  	render html: "<li><span class='author-info'>#{User.find(session[:logged_user_id]).username}</span><span class='message'>#{params['message']}</span></li>".html_safe
  end

  def notification
    connection    = ActiveRecord::Base.connection
    @notification = connection.execute("SELECT photos.id, photos.name,
                                               comments.message
                                          FROM comments
                                          JOIN photos ON photos.id = comments.id_photo
                                         WHERE photos.id_user = #{session[:logged_user_id]}
                                           AND comments.is_notified = 0
                                      ORDER BY comments.id DESC
                                         LIMIT 1")

    connection.execute("UPDATE comments
                           SET is_notified = 1
                         WHERE id_photo = #{@notification.first.first}") if @notification.first.present?

    render nothing: true if @notification.first.blank?
  end
end
