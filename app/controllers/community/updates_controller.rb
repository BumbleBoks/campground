class Community::UpdatesController < ApplicationController
  before_action :set_community_update, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user
  
  def create
    @update = current_user.updates.build(community_update_params)
    if @update.save
      redirect_to common_trail_path(trail_link(@update.trail))
    else
      redirect_to common_trail_path(trail_link(@update.trail))
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_update
      @community_update = Community::Update.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_update_params
      params.require(:community_update).permit(:content, :trail_id)
    end
end
