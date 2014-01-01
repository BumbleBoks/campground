class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def invite_message(request)
    @invite_url = edit_site_user_request_url(request.token, only_path: false)
    subject = "OnTrailAgain Invitation"
    to_email = request.email
    mail to: to_email, subject: subject    
  end

  def welcome_message(user)
    @user = user
    @site_url = root_url(only_path: false)
    subject = "Welcome to OnTrailAgain"
    to_email = "#{user.name} <#{user.email}>"
    mail to: to_email, subject: subject
  end
  
  def reset_password_message(user, request)
    @user = user
    @reset_url = edit_site_user_request_url(request.token, only_path: false)
    subject = "Your OnTrailAgain Account"
    to_email = "#{@user.name} <#{@user.email}>"
    mail to: to_email, subject: subject
  end
  
  def add_trail_message(missing_trail)
    @user_name = missing_trail.user_name
    @user_email = missing_trail.user_email
    @trail_info = missing_trail.info
    subject = "Add a new trail"
    to_email = "#{@user_name} <#{@user_email}>"
    bcc_email = ENV['MAIL_USERNAME']
    mail to: to_email, bcc: bcc_email, subject: subject
  end
  
  def test_message
    @root_url = root_url(only_path: false)
    subject = "OnTrailAgain Test Message"
    to_email = "info@ontrailagain.com"
    mail to: to_email, subject: subject    
  end
  
end
