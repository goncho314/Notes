class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :no_content }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_by username: params[:username]
    if @user or params[:username]=="" or params[:password]==""
      respond_to do |format|
        format.html { redirect_to signup_path, alert: 'User was not created.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    else
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          session[:user] = @user.username
          session[:role] = @user.role
          format.html { redirect_to root_path, success: 'User: '+@user.username+' was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
       format.html { redirect_to signup_path, alert: 'User was not created.' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find_by username: params[:username]
    if @user or params[:username]=="" or params[:password]==""
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, success: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find_by username: session[:user]
    @user.destroy
    session[:user] = nil
    session[:role] = nil
    respond_to do |format|
      format.html { redirect_to root_path, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_admin
    @user = User.find_by id: params[:id]
    @user.destroy
    respond_to do |format|
      format.html { redirect_to management_index_path, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def friendrequest
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.friend_request(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, success: 'Request was successfully sended.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def removefriend
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    Note.all.each do |note|
      if note.owner.id == @current_user.id
        if note.user_ids.include? @user.id
          shared_users = note.user_ids
          shared_users.delete(params[:n_id].to_i)
          note.user_ids = shared_users
        end
      elsif note.owner.id == @user.id
        if note.user_ids.include? @current_user.id
          shared_users = note.user_ids
          shared_users.delete(params[:id].to_i)
          note.user_ids = shared_users
        end
      end
      note.save
    end
    @current_user.remove_friend(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, success: 'Friendship was successfully removed.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def removefriend_admin
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.remove_friend(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to management_index_path, success: 'Friendship was successfully removed.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def acceptrequest
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.accept_request(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, success: 'Friendship was accepted.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def declinerequest
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.decline_request(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, success: 'Friendship was declined.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def cancelrequest
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @user.decline_request(@current_user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, success: 'Friendship request was canceled.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:username, :password)
    end
end
