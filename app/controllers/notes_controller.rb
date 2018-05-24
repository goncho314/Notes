class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @all_notes = Note.all
    @current_user = User.find_by username: session[:user]
    @notes = []
    @all_notes.each do |note|
      if note.owner.id == @current_user.id or note.user_ids.include? @current_user.id
        @notes.push(note)
      end
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @current_user = User.find_by username: session[:user]
    if @note.owner.id == @current_user.id or @note.user_ids.include? @current_user.id
      @collections = Collection.all
      @users = User.all
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You don't have permission to see this note." }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  # GET /notes/new
  def new
    if session[:user] != nil
      @note = Note.new
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  # GET /notes/1/edit
  def edit
    @current_user = User.find_by username: session[:user]
    if @note.owner.id == @current_user.id or @note.user_ids.include? @current_user.id
      @all_users = User.all
      @users = []
      @all_users.each do |user|
        if (@note.owner.id != user.id or @note.user_ids.include? user.id) and @current_user.id != user.id
          @users.push(user)
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You don't have permission to edit this note." }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.owner = User.find_by username: session[:user]
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, success: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { redirect_to @note, alert: 'Note was not created.' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, success: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { redirect_to @note, alert: 'Note was not updated.' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    if session[:user] != nil
      @current_user = User.find_by username: session[:user]
      if @note.owner.id == @current_user.id or @note.user_ids.include? @current_user.id
        @note.destroy
        respond_to do |format|
          format.html { redirect_to notes_url, success: 'Note was successfully destroyed.' }
          format.json { render :show, status: :created, location: @note }
        end
      else
        respond_to do |format|
          format.html { redirect_to root_path, alert: "You don't have permission to delete this note." }
          format.json { render :show, status: :created, location: @note }
        end
      end   
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  def destroy_note_admin
    if session[:role] == "Admin"
      @note = Note.find_by id: params[:id]
      @note.destroy
      respond_to do |format|
        format.html { redirect_to management_index_path, success: 'Note was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not admin" }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  def share
    @current_user = User.find_by username: session[:user]
    @shared_user = User.find_by id: params[:n_id]
    if @current_user.friends_with?(@shared_user)
      @note = Note.find_by id: params[:id]
      if @note.owner.id != @shared_user.id
        users = @note.user_ids
        users.push(params[:n_id].to_i)
        @note.user_ids = users
        respond_to do |format|
          if @note.save
            format.html { redirect_to @note, success: 'Note was successfully shared.' }
            format.json { render :show, status: :ok, location: @note }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to edit_note_path, alert: "You can't share a note with its owner." }
          format.json { head :no_content }
        end    
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_note_path, alert: 'This user is not your friend.' }
        format.json { head :no_content }
      end
    end
  end

  def stopsharing
    @current_user = User.find_by username: session[:user]
    @note = Note.find_by id: params[:id]
    if @note.owner.id == @current_user.id or @note.user_ids.include? @current_user.id
      users = @note.user_ids
      users.delete(params[:n_id].to_i)
      @note.user_ids = users
      respond_to do |format|
        if @note.save
          format.html { redirect_to @note, success: 'Note sharing stopped.' }
          format.json { render :show, status: :ok, location: @note }
        end
      end  
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You don't have permission to edit this note." }
        format.json { render :show, status: :created, location: @note }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:user_id, :text, :image)
    end
end
