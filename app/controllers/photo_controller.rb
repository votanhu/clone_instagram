class PhotoController < ApplicationController
  before_action :set_user, only: [:feeds, :upload]

  def feeds
    connection   = ActiveRecord::Base.connection
    photo_feeds  = connection.execute("SELECT photos.id, photos.url, photos.created_at,
                                              users.username,
                                              comments.id, comments.message
                                         FROM users
                                         JOIN follows ON follows.id_user = users.id AND follows.id_follower = #{session[:logged_user_id]}
                                         JOIN photos ON photos.id_user = users.id
                                    LEFT JOIN comments ON comments.id_photo = photos.id
                                     ORDER BY photos.created_at
                                        LIMIT 10")
    redirect_to :controller => :user, :action => :follow if photo_feeds.first.blank?

    @feeds = {}
    photo_feeds.each do |row|
      @feeds[row[0]]                      ||= {}
      @feeds[row[0]]['photo_url']         ||= row[1]
      @feeds[row[0]]['created_at']        ||= row[2].strftime("%d/%m/%Y")
      @feeds[row[0]]['user_name']         ||= row[3]
      @feeds[row[0]]['comments']          ||= {}
      @feeds[row[0]]['comments'][row[4]]  ||= row[5]
    end
  end

  def upload
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:logged_user_id])
    end
end
