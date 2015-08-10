class UserController < ApplicationController
	before_action :set_user, only: [:updateuser, :editprofile, :changepassword, :updatepassword, :follow]

  def profile
  	connection = ActiveRecord::Base.connection
		user_info  = connection.execute("SELECT users.id, users.username, users.name,
																						COUNT(photos.id) AS total_post
												               FROM users
										              LEFT JOIN photos ON photos.id_user = users.id
												              WHERE users.id = #{session[:logged_user_id]}")
		@user             = User.new
		@user.id 					= user_info.first.first
		@user.username    = user_info.first.second
		@user.name        = user_info.first.third
		@total_post       = user_info.first.last
		@total_follower   = Follow.where(:id_user => session[:logged_user_id]).count
		@total_following  = Follow.where(:id_follower => session[:logged_user_id]).count
  end

  def editprofile
  end

  def changepassword
  end

  def updatepassword
  	if params['user'].present?
  		respond_to do |format|
        @user.errors.add(:old_password_not_match, 'Old password is not correct!') if params['user']['oldpassword'] != @user.password
        @user.errors.add(:old_password_not_match, 'New password is not confirmed!') if params['user']['password'] != params['user']['confirmpassword']
        if@user.errors.blank?
        	@user.password = params['user']['password']
        	@user.save
        	format.html { redirect_to :action => 'changepassword', notice: 'Password has been changed successfully.' }
        else
        	format.html { render :changepassword }
        end
      end
  	end
  end

  def follow
  	connection 		= ActiveRecord::Base.connection
		@suggest_user = connection.execute("SELECT users.id, users.username, users.name
																			    FROM users
																	   LEFT JOIN follows ON follows.id_user = users.id AND follows.id_follower = #{session[:logged_user_id]}
																			   WHERE follows.id_user IS NULL AND similiar_account_suggestion = 1
																			   LIMIT 10")
  end

  def updatefollow
  	Follow.find_or_create_by(id_user: params['follow'], id_follower: session[:logged_user_id])
  	redirect_to :controller => :user, :action => :follow
  end

  def updateuser
  	respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :action => 'editprofile', notice: 'Profile was successfully updated.' }
      else
        format.html { render :editprofile }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:logged_user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :name, :email, :bio, :phone, :website, :sex, :similiar_account_suggestion)
    end
end
