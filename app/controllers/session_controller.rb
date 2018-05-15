class SessionController < ApplicationController
  def index
  	@users = User.all
  end

  def new
  end

  def create
  	@user = User.find_by username: params[:username]
		if !@user
			flash.now.alert = "Username or password are invalid"
			render :new
		elsif @user.password == params[:password]
			session[:user] = @user.username
		 	redirect_to root_url
		else
		 	flash.now.alert = "Username or password are invalid"
		 	render :new
	 	end
  end

  def destroy
  	session[:user] = nil
	redirect_to :root
  end
end
