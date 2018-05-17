class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @collections = Collection.all
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
    @users = User.all
    @current_user = User.find_by username: session[:user]
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user = User.find_by username: session[:user]
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def share
    @note = Note.find_by id: params[:id]
    @owner = @note.user
    users = @note.user_ids
    users.push(params[:n_id].to_i)
    users.delete(@owner.id)
    @note.user_ids = users
    @user = User.find_by id: params[:n_id]    
    notes = @user.note_ids
    notes.push(params[:id].to_i)
    @user.note_ids = notes
    @note.user = @owner
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully shared.' }
        format.json { render :show, status: :ok, location: @note }
      end
    end
  end

  def stopsharing
    @note = Note.find_by id: params[:id]
    @owner = @note.user
    users = @note.user_ids
    users.delete(params[:n_id].to_i)
    @note.user_ids = users
    @user = User.find_by id: params[:n_id]
    notes = @user.note_ids
    notes.delete(params[:id].to_i)
    @user.note_ids = notes
    @note.user = @owner
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note sharing stopped.' }
        format.json { render :show, status: :ok, location: @note }
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
