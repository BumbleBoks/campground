class ApplicationController < ActionController::Base
  before_action :set_no_cache
  after_action :flash_to_headers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  force_ssl
    
  # helpers
  include ApplicationHelper
  include SessionsHelper
  include Corner::LogsHelper
  include Common::TrailsHelper
  include Community::TradesHelper
  
  private
  def set_no_cache
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, no-transform, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      # response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
      # expires_in 0.second, public: false, must_revalidate: true
      response.headers["Expires"] = "#{1.second}"
  end

end
