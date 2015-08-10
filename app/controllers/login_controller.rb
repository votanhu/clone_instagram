class LoginController < ApplicationController
  skip_before_filter :check_token

  def registration
    @login = User.new
    if params['user'].present?
      @login = User.new(user_params)
      @login.password = Digest::MD5.hexdigest(@login.password)
      if params['user']['password'].present? && @login.save
        session[:logged_user_id] = @login.id
        redirect_to :controller => :photo, :action => :feeds
      else
        respond_to do |format|
          @login.errors.add(:password, "is invalid") if params['user']['password'].blank?
          format.html { render :registration }
        end
      end
    end
  end

  def signin
    @login ||= User.new
  end

  def login
    login_user = User.find_by(:username => params['user']['username'], :password => Digest::MD5.hexdigest(params['user']['password']))
    if login_user
      session[:logged_user_id] = login_user.id
      if Follow.where(:id_follower => login_user.id).limit(1).count
        redirect_to(:controller => :user, :action => :follow)
      else
        redirect_to(:controller => :user, :action => :profile)
      end
    else
      respond_to do |format|
        @login = User.new
        @login.errors.add(:invalid_account, 'Your username or password was incorrect.')
        format.html { render :signin }
      end
    end
  end

  def signout
    session[:logged_user_id] = nil
    redirect_to :controller => :login, :action => :signin
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :email)
    end
end
