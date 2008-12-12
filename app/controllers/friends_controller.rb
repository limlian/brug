class FriendsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_user_id])
    @user.add_friend(@friend)
    redirect_to user_url(:id => @user.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    @friend = User.find(params[:friend_user_id])
    @user.remove_friend(@friend)
  end
end
