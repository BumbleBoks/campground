class Common::MissingTrailsController < ApplicationController
  before_action :authorize_user, only: [:create]
  before_action :authorize_admin, except: [:create]
    
  def index
    @missing_trails = Common::MissingTrail.all  
  end  
  
  def create
    @missing_trail = Common::MissingTrail.new(missing_trail_create_params)
    @missing_trail.user_name = current_user.name
    @missing_trail.user_email = current_user.email
    if @missing_trail.save 
      UserMailer.add_trail_message(@missing_trail).deliver
      flash[:success] = "Missing trail info has been recorded."
    else
      flash[:error] = "Could not record the info on missing trail."
    end
    redirect_to :back
  end
  
  def edit
    @missing_trail = Common::MissingTrail.find(params[:id])
  end
  
  def update
    @missing_trail = Common::MissingTrail.find(params[:id])
    missing_trail_update_params[:updates].concat("\n" + @missing_trail.updates.to_s)
    @missing_trail.update_attributes(missing_trail_update_params)    
    redirect_to edit_common_missing_trail_path(@missing_trail)
  end
  
  def destroy
    @missing_trail = Common::MissingTrail.find(params[:id])
    @missing_trail.destroy
    redirect_to common_missing_trails_path    
  end
  
  private
  
  def missing_trail_create_params
    params.require(:common_missing_trail).permit(:info)
  end  
  
  def missing_trail_update_params
    params.require(:common_missing_trail).permit(:updates)
  end
end
