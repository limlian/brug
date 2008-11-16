class LoginController < ApplicationController
  
  def index
  end

  def login
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if !user.nil?
        session[:user_id] = user.id
        redirect_to url_for(:controller => "home", :action => 'index')
      else
        redirect_to :action => "index"
        flash[:notice] = 'Invalid email/password combination'
      end
    end
  end
end
