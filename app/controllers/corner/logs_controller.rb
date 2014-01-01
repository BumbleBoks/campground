class Corner::LogsController < ApplicationController
  before_action :authorize_user
  before_action :get_date_and_log, only: [:show, :edit]
  
  # def new
  #   @log = current_user.logs.build
  #   @tag = @log.tags.build
  # end
  # 
  # def create    
  #   @log = current_user.logs.build(log_params)
  #   if @log.save && @log.update_tags(log_tag_params[:tags_attributes])
  #     flash[:success] = "Log successfully added"
  #     redirect_to generate_log_path(@log)
  #   else
  #     render 'new'
  #   end
  # end
    
  def edit
    @tags = @log.tags.build
  end
  
  def update 
    @log = current_user.logs.find_by(log_date: log_params[:log_date])
    if @log.nil?
      @log = current_user.logs.build(log_params)
    end
    
    if @log.update(log_params) && @log.update_tags(log_tag_params[:tags_attributes])
        flash[:success] = "Log successfully saved"
        redirect_to generate_log_path(@log)
      else
        render 'edit'
      end      
  end
        
    
  def show
    if @log.nil?
      @log = current_user.logs.build(log_date: @date)
      @tag = @log.tags.build
      render 'edit'
    end
  end
  
  def destroy
    @log = current_user.logs.find_by(id: params[:id])
    log_date = @log.log_date
    @log.destroy
    redirect_to(corner_logs_path(log_date.year, log_date.month, log_date.day))
  rescue    
    redirect_to root_path
    # unless @log.nil?    
    #   log_date = @log.log_date
    #   @log.destroy
    #   redirect_to(corner_logs_path(log_date.year, log_date.month, log_date.day))
    # end
  end
  
  
  private 
  
  def get_date_and_log
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @log = current_user.logs.find_by(log_date: @date)  
    @log_dates = current_user.logs.map { |l| l.log_date.to_formatted_s(:calendar_date) } 
  end
    
  def log_params
    params.require(:corner_log).permit(:activity_id, :content, :log_date, :title)
  end
  
  def log_tag_params
    params.require(:corner_log).permit(tags_attributes: [:name] )
  end
  
end
