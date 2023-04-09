class RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])#[]の中が:idじゃないからrails routesをしたときにurl内のidがuser_idという表記だから。カラムとは関係ない。
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
	  @users = user.followers
  end
end

