class MessagesController < ApplicationController
  before_filter :authorize

  def index
    @messages = @viewer.received_messages
  end

  def create
    case params[:message_type]
    when "friend_invitation"
      create_friend_invitation(params)
    else
      redirect_to :controller => "home"
    end
  end

  private

  def create_friend_invitation(params)
    @user = User.find_by_id(params[:user_id])
    @invitation_user = User.find_by_id(params[:invitation_user_id])

    unless @user.is_my_friend? @invitation_user
      @friend_inivation_message = FriendInvitationMessage.find_or_initialize_by_from_user_id_and_to_user_id(@invitation_user.id, @user.id)
      @friend_inivation_message.status = params[:status]

      if @friend_inivation_message.save
        flash[:notice] = "Friend invitation sent!"
      else
        flash[:notice] = "Friend invitation not sent!"
      end      
    end
    
    redirect_to user_url(@user)
  end
end
