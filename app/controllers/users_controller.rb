class UsersController < ApplicationController
  before_action :guest_user, :only => [:new, :create, :invite_user]
  before_action :authorize_user, :only => [:show, :edit, :update, :destroy]
  before_action :account_owner, :only => [:edit, :update, :destroy]
  
  def show
    # @user = User.find_by(id: params[:id])
    @user = User.find_by(login_id: params[:id])
    @updates = @user.updates.page(params[:page])
    
    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def invite_user    
  end
  
  def new
    @user = User.new
  end
  
  def create
    trim_whitespace_from_params(user_new_params)
    email = Site::UserRequest.find_by(token: user_new_params[:token]).email
    user_params = user_new_params.merge({email: email})
    user_params.delete(:token)
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_message(@user).deliver
      log_in @user
      redirect_to root_path
    else
      @token = user_new_params[:token]
      render 'new'
    end
  end

  def edit
    @user_login = @user.login_id
    @page = params[:page] || 1
  end

  def update   
    trim_whitespace_from_params(user_edit_params)
    @user_login = @user.login_id
    if @user.update_partial_attributes(user_edit_params) 
      if params[:page].present? && params[:page].to_i.eql?(2)
        flash[:success] = "Password successfully changed"
        redirect_to edit_user_path(@user.login_id)
      else  
        redirect_to user_path(@user.login_id)
      end
    else
      @page = params[:page]
      render 'edit'
    end
  end
  
  def destroy
    user_login = @user.login_id
    @user.destroy
    flash[:success] = "User profile for #{user_login} deleted"
    redirect_to root_path
  end

  private
  def account_owner
    # @user = User.find_by(id: params[:id])
    @user = User.find_by(login_id: params[:id])
    unless current_user?(@user)
      redirect_to root_path
      false
    end
  end
  
  def user_edit_params
    params.require(:user).permit(:login_id, :name, :current_password, :password, :password_confirmation)
  end

  def user_new_params
    params.require(:user).permit(:login_id, :name, :current_password, :password, :password_confirmation, :token)
  end
  
  def trim_whitespace_from_params(params)
    params[:login_id].strip! unless params[:login_id].nil?
    params[:name].strip! unless params[:name].nil?
  end
end
