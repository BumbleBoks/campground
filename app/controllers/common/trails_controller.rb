class Common::TrailsController < ApplicationController
  before_action :set_common_trail, only: [:show, :edit, :update]
  before_action :authorize_admin, except: [:index, :show, :search]
  
  def index
  end
  
  def show
    if logged_in?
      @update = current_user.updates.build
    end    
    @trail_updates = @trail.updates.page(params[:page])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    @trail = Common::Trail.new
  end
  
  def create
    @trail = Common::Trail.new(trail_params)
    if @trail.save
      redirect_to(edit_common_trail_path(trail_link(@trail)))
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @trail.update_attributes(trail_params)
      redirect_to common_trail_path(trail_link(@trail))
    else
      redirect_to edit_common_trail_path(trail_link(@trail))
    end
  end
  
  def search
    params_array = params[:name].downcase.split(",")
    trail_name = params_array[0].strip
    if params_array[1].nil?
      state_name = ""
    else
      state_name = params_array[1].strip
    end
    @trails = Common::Trail.where("LOWER(name) LIKE ?", "%#{trail_name}%").keep_if \
      { |t| t.state.name.downcase.include?(state_name) }
    respond_to do |format|
      format.js { render partial: 'shared/select_trail', locals: {trails: @trails} }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_common_trail
    # @trail = Common::Trail.find(params[:id])
    find_params = params[:id].split(trail_link_separator).map { |p| p.strip }
    @trail = Common::Trail.includes(:state).where("common_states.name = ?", find_params[1])\
      .references(:common_states).find_by(name: find_params[0])
  end
  
  def trail_params
    params.require(:common_trail).permit(:description, :length, :name, :state_id, 
      { activity_ids: [] })
  end
  
end
