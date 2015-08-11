class PhotoController < ApplicationController
  before_action :set_user, only: [:feeds, :upload]

  def feeds
    connection   = ActiveRecord::Base.connection
    if params['keyword'].present?
      all_hashtag  = params['keyword'].scan(/[[:alnum:]]+/).join("','")
      photo_feeds  = connection.execute("SELECT photos.id, photos.url, photos.created_at,
                                                users.username
                                           FROM users
                                           JOIN follows ON follows.id_user = users.id AND follows.id_follower = #{session[:logged_user_id]}
                                           JOIN photos ON photos.id_user = users.id
                                           JOIN photo_hashtags ON photo_hashtags.id_photo = photos.id
                                           JOIN hashtags ON hashtags.id = photo_hashtags.id_tag
                                          WHERE hashtags.tag IN('#{all_hashtag}')
                                       ORDER BY photos.created_at DESC")
    else
      photo_feeds  = connection.execute("SELECT photos.id, photos.url, photos.created_at,
                                                users.username
                                           FROM users
                                           JOIN follows ON follows.id_user = users.id AND follows.id_follower = #{session[:logged_user_id]}
                                           JOIN photos ON photos.id_user = users.id
                                       ORDER BY photos.created_at DESC")

      redirect_to :controller => :user, :action => :follow if photo_feeds.first.blank?
    end

    @feeds = {}
    photo_feeds.each do |row|
      @feeds[row[0]]                      ||= {}
      @feeds[row[0]]['photo_url']         ||= row[1]
      @feeds[row[0]]['created_at']        ||= row[2].strftime("%d/%m/%Y")
      @feeds[row[0]]['user_name']         ||= row[3]
      @feeds[row[0]]['comments']          ||= {}

      comments = connection.execute("SELECT comments.id, comments.message, comment_user.username AS commentor
                                      FROM comments
                                      JOIN users AS comment_user ON comments.id_user = comment_user.id
                                     WHERE comments.id_photo = #{row[0]}
                                  ORDER BY comments.id DESC")
      comments.each do |comment|
        @feeds[row[0]]['comments'][comment[0]]  ||= {:username => comment[2], :message => comment[1]}
      end
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

    res_hash         = {
                          :name => params['photo'][:info].original_filename,
                          :size => 9000,
                          :url  => "/photos/#{@upload.url}",
                          :delete_url  => upload_path(@upload),
                          :delete_type => "DELETE"
                        }
    respond_to do |format|
      if @upload.save
        FileUtils.mkdir_p(File.dirname(dest_img)) unless File.directory?(File.dirname(dest_img))
        File.rename params['photo'][:info].path, dest_img

        format.json { render json: { files: [res_hash] }, status: :created, location: @upload.url }
      else
        res_hash[:errors] = @upload.errors
        format.json { render json: { files: [res_hash] }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:logged_user_id])
    end
end
