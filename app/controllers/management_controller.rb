class ManagementController < ApplicationController
  def index
    if session[:role] == "Admin"
    	@users = User.all
    	@notes = Note.all
    	@collections = Collection.all
    	@friendships = []
    	@users.each do |user|
    		user.friends.each do |friend|
    			if user.id<friend.id
    				 @relationship = {:user1 => user, :user2 => friend}
    				 @friendships.push(@relationship)
    			end
    		end
    	end
    	@current_user = User.find_by username: session[:user]
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not admin" }
        format.json { head :no_content }
      end
    end
  end
end
