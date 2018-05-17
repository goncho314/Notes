class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_by username: params[:username]
    if @user or params[:username]=="" or params[:password]==""
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    else
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          session[:user] = @user.username
          format.html { redirect_to root_path, notice: 'User: '+@user.username+' was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
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
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def friendrequest
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.friend_request(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, notice: 'Request was successfully sended.' }
        format.json { render :edit, status: :ok, location: @current_user }
      end
    end
  end

  def removefriend
    @current_user = User.find_by id: params[:id]
    @user = User.find_by id: params[:n_id]
    @current_user.remove_friend(@user)
    respond_to do |format|
      if @current_user.save
        format.html { redirect_to friends_index_path, notice: 'Friendship was successfully removed.' }
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
        format.html { redirect_to friends_index_path, notice: 'Friendship was accepted.' }
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
        format.html { redirect_to friends_index_path, notice: 'Friendship was declined.' }
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
        format.html { redirect_to friends_index_path, notice: 'Friendship request was canceled.' }
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
