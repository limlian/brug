class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        format.html {redirect_to :controller => 'login'}
      else
        format.html {redirect_to :action => "new"}
      end
    end
  end
end
