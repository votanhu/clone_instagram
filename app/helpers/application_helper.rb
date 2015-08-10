module ApplicationHelper
  def is_user_logged?
    return session[:logged_user_id].present?
  end
end
