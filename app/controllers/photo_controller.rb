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
    @upload          = Photo.new()
    @upload.id_user  = session[:logged_user_id]
    @upload.name     = params['photo'][:info].original_filename
    ext              = @upload.name.split(".").last
    random_file_name = "#{[*('a'..'z'),*('A'..'Z')].to_a.shuffle[0,52].join}#{Time.now.to_i}"
    @upload.url      = File.join(session[:logged_user_id].to_s, "#{random_file_name}.#{ext}")
    dest_img         = Rails.root.join('public', 'photos', session[:logged_user_id].to_s, "#{random_file_name}.#{ext}")

    respond_to do |format|
      if @upload.save
        FileUtils.mkdir_p(File.dirname(dest_img)) unless File.directory?(File.dirname(dest_img))
        File.rename params['photo'][:info].path, dest_img

        format.html {
          render :json => @upload.to_json,
          :content_type => 'text/html',
          :layout => false
        }
      else
        format.html {
          render :json => "failed".to_json,
          :content_type => 'text/html',
          :layout => false 
        }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:logged_user_id])
    end
end
