class SessionsController < ApplicationController
  before_action :guest_user, :only => [:new, :create]
  
  def new  
    # for testing mail configuration
    # UserMailer.test_message.deliver
  end
  
  def create
    user = User.find_by(login_id: params[:login_id].downcase)
    reset_session
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to(root_path)
    else
      flash.now[:error] = "Login ID/password combination not found."
      render 'new'
    end
  end
  
  def destroy
    log_out
    reset_session
    flash[:success] = "Logged out!"
    redirect_to root_path
  end
end
