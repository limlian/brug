class UsersController < ApplicationController
  before_filter :authorize, :only => [:show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "Registration successed"
        format.html {redirect_to :controller => 'login'}
      else
        format.html {render :action => "new"}
      end
    end
  end

  def show
    @owner = User.find_by_id(params[:id])
  end
end
