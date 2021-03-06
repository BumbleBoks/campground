module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  def log_out
    current_user = nil;
    session.delete(:user_id)
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]    
  end
  
  def current_user?(user)
    current_user == user
  end
  
  def logged_in?
    !current_user.nil?
  end
    
end
