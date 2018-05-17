class FriendsController < ApplicationController
  def index
  	@users = User.all
  	@current_user = User.find_by username: session[:user]
  end
end
