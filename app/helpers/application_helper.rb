module ApplicationHelper
  def authorize_admin
    unless current_user && current_user.admin?
      redirect_to root_path
      false
    end
  end
  
  def authorize_user
    unless current_user
      redirect_to login_path
      false
    end
  end
  
  def guest_user
    if logged_in?
      redirect_to root_path
      false
    end
  end
  
  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers['X-Message-Type'] = flash_type.to_s
  end
  
  def flash_message
    unless flash.blank?
      flash[flash.keys.first]
    end
  end
  
  def flash_type  
    unless flash.blank?
      flash.keys.first
    end
  end
    
  def div_for_side_panes
    if logged_in? 
      div_name = "title_board"
    else
      div_name = "title_board inactive"
    end
  end
        
  # def output_with_commas(elements, attribute)
  #   output_string = ""
  #   if elements.first.respond_to?(attribute)
  #     elements.each do |element|
  #       if !(element == elements.first) 
  #         output_string += ", "
  #       end
  #       output_string += element.send(attribute).to_s         
  #     end
  #     output_string
  #   end
  # end
  
  def text_with_newlines(input_string)
    input_string.to_s.gsub(/\n/, "#{tag('br')}").html_safe
  end
  
  def shorten_string(input_string)
    if input_string.length < 40
      input_string
    else
      input_string[1..40] + "..."
    end
  end
  
  def url_for_avatar(user, size)
    gravatar_id_hash = Digest::MD5::hexdigest(user.email.strip.downcase)
    # "http://www.gravatar.com/avatar/#{gravatar_id_hash}?s=#{size}&r=g"
    "https://secure.gravatar.com/avatar/#{gravatar_id_hash}?s=#{size}&r=g"
  end
  
end
