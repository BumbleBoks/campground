class Site::UserRequestsController < ApplicationController
    def create
      case params[:user_request]      
      when "reset_password"
        create_reset_password_request

      when "get_invite"  
        create_invite_user_request      
      end

      return if @user_request.nil?

      if @user_request.save
        @user_email.deliver
        flash[:success] = @success_message
        redirect_to root_path          
      else
        flash[:error] = "Email not sent. Try again."
        redirect_to :back
      end    
    end

    def edit_request
      user_request = Site::UserRequest.find_by(token: params[:token])
      if user_request
        case user_request.request_type
        when "password"
          @user = User.find_by(email: user_request.email)
          if @user
            render 'reset_password'
          else
            flash[:error] = 'User not found'
            redirect_to root_path          
          end

        when "newuser"  
          @user = User.new
          @user.email = user_request.email
          @token = user_request.token
          render 'users/new'
        end
      else
        redirect_to root_path
      end
    end

    def process_request
      user_request = Site::UserRequest.find_by(token: params[:token])
      if user_request
        case user_request.request_type
        when "password"
          @user = User.find_by(email: user_request.email)
          user_attributes = { password: params[:password], 
                              password_confirmation: params[:password_confirmation] }

          if @user.set_partial_attributes(user_attributes)
            log_in @user
            flash[:success] = "Password was reset."
            redirect_to root_path
          else
            render 'reset_password'
          end # resetting password

        end # different request types
      else # no user_request found
        redirect_to root_path
      end
    end

  private
    def create_reset_password_request
      user_login_id = downcase_and_trim_whitespace(params[:user_login_id])
      @user = User.find_by(login_id: user_login_id)
      if @user      
        @user_request = Site::UserRequest.generate_new(@user.email, "password")
        @user_email = UserMailer.reset_password_message(@user, @user_request)
        @success_message = "Email for resetting password sent"
      else
        flash[:error] = "Login ID not found"
        redirect_to login_path
      end  
    end

    def create_invite_user_request
      user_invite_email = downcase_and_trim_whitespace(params[:invite_email])
      @user = User.find_by(email: user_invite_email)
      if @user.nil?
        @user_request = Site::UserRequest.generate_new(user_invite_email, "newuser")
        @user_email = UserMailer.invite_message(@user_request)
        @success_message = "Invite sent"
      else
        flash[:error] = "Account with that email already exists"
        redirect_to login_path
      end            
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_user_request_params
      params[:site_user_request]
    end   
    
    def downcase_and_trim_whitespace(input_string)
      input_string.downcase.strip
    end 
end
