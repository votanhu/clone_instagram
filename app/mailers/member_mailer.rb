class MemberMailer < ActionMailer::Base
  default from: Rails.application.config.clone_instagram_mail['username']

  def notify_has_new_follower(id_user, id_follower)
  	@receiver = User.find(id_user)
  	@follower = User.find(id_follower)
  	subject = "You have a new follower"
  	mail(to: @receiver.email, subject: subject)
  end
end
