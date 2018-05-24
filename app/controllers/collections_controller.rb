class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  # GET /collections
  # GET /collections.json
  def index
    @all_collections = Collection.all
    @current_user = User.find_by username: session[:user]
    @collections = []
    @all_collections.each do |collection|
      if collection.owner.id == @current_user.id or collection.user_ids.include? @current_user.id
        @collections.push(collection)
      end
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @all_notes = Note.all
    @current_user = User.find_by username: session[:user]
    @notes = []
    @all_notes.each do |note|
      if @collection.note_ids.include? note.id
        @notes.push(note)
      end
    end
    @current_user = User.find_by username: session[:user]
    if @collection.owner.id == @current_user.id or @collection.user_ids.include? @current_user.id
      @users = User.all
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You don't have permission to see this collection." }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  # GET /collections/new
  def new
    if session[:user] != nil
      @collection = Collection.new
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  # GET /collections/1/edit
  def edit
    @all_notes = Note.all
    @current_user = User.find_by username: session[:user]
    @notes = []
    @all_notes.each do |note|
      if @collection.note_ids.include? note.id or note.owner.id == @current_user.id or note.user_ids.include? @current_user.id
        @notes.push(note)
      end
    end
    @all_users = User.all
      @users = []
      @all_users.each do |user|
      if (@collection.owner.id != user.id or @collection.user_ids.include? user.id or @current_user.friends_with?(user)) and @current_user.id != user.id
        @users.push(user)
      end
    end
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    @collection.owner = User.find_by username: session[:user]
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, success: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { redirect_to @collection, alert: 'Collection was not created.' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, success: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { redirect_to @collection, alert: 'Collection was not updated.' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    if session[:user] != nil
      @current_user = User.find_by username: session[:user]
      if @collection.owner.id == @current_user.id or @collection.user_ids.include? @current_user.id
        @collection.destroy
        respond_to do |format|
          format.html { redirect_to collections_url, success: 'Collection was successfully destroyed.' }
          format.json { render :show, status: :created, location: @collection }
        end
      else
        respond_to do |format|
          format.html { redirect_to root_path, alert: "You don't have permission to delete this collection." }
          format.json { render :show, status: :created, location: @collection }
        end
      end   
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  def destroy_collection_admin
    if session[:role] == "Admin"
      @collection = Collection.find_by id: params[:id]
      @collection.destroy
      respond_to do |format|
        format.html { redirect_to management_index_path, success: 'Collection was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not admin" }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  def addnote
    if session[:user] != nil
      @current_user = User.find_by username: session[:user]
      @collection = Collection.find_by id: params[:id]
      @note = Note.find_by id: params[:n_id]
      if (@note.user_ids.include? @current_user.id or @note.owner.id == @current_user.id) and (@collection.user_ids.include? @current_user.id or @collection.owner.id==@current_user.id)
        notes = @collection.note_ids
        notes.push(params[:n_id].to_i)
        @collection.note_ids = notes
        @note = Note.find_by id: params[:n_id]    
        collections = @note.collection_ids
        collections.push(params[:id].to_i)
        @note.collection_ids = collections
        respond_to do |format|
          if @collection.save
            format.html { redirect_to @collection, success: 'Collection was successfully updated.' }
            format.json { render :show, status: :ok, location: @collection }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to root_path, alert: "You don't have permission to add this note to the collection." }
          format.json { render :show, status: :created, location: @collection }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  def removenote
    if session[:user] != nil
      @current_user = User.find_by username: session[:user]
      @collection = Collection.find_by id: params[:id]
      @note = Note.find_by id: params[:n_id]
      if @collection.user_ids.include? @current_user.id or @collection.owner.id == @current_user.id
        if @collection.note_ids.include? @note.id
          notes = @collection.note_ids
          notes.delete(params[:n_id].to_i)
          @collection.note_ids = notes
          collections = @note.collection_ids
          collections.delete(params[:id].to_i)
          @note.collection_ids = collections
          respond_to do |format|
            if @collection.save
                format.html { redirect_to @collection, success: 'Collection was successfully updated.' }
                format.json { render :show, status: :ok, location: @collection }
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to root_path, alert: "This note doesn't belong to the collection." }
            format.json { render :show, status: :created, location: @collection }
          end  
        end        
      else
        respond_to do |format|
          format.html { redirect_to root_path, alert: "You don't have permission to remove this note from the collection." }
          format.json { render :show, status: :created, location: @collection }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not registered" }
        format.json { render :show, status: :created, location: @collection }
      end
    end
  end

  def share
    @current_user = User.find_by username: session[:user]
    @shared_user = User.find_by id: params[:n_id]
    if @current_user.friends_with?(@shared_user)
      @collection = Collection.find_by id: params[:id]
      if @collection.owner.id != @shared_user.id
        users = @collection.user_ids
        users.push(params[:n_id].to_i)
        @collection.user_ids = users
        respond_to do |format|
          if @collection.save
            format.html { redirect_to @collection, success: 'Collection was successfully shared.' }
            format.json { render :show, status: :ok, location: @collection }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to edit_collection_path, alert: "You can't share a collection with its owner." }
          format.json { head :no_content }
        end    
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_collection_path, alert: 'This user is not your friend.' }
        format.json { head :no_content }
      end
    end
  end

  def stopsharing
    @current_user = User.find_by username: session[:user]
    @shared_user = User.find_by id: params[:n_id]
    if @current_user.friends_with?(@shared_user)
      @collection = Collection.find_by id: params[:id]
      if @collection.owner.id != @shared_user.id
        users = @collection.user_ids
        users.delete(params[:n_id].to_i)
        @collection.user_ids = users
        respond_to do |format|
          if @collection.save
            format.html { redirect_to @collection, success: 'Collection sharing stopped.' }
            format.json { render :show, status: :ok, location: @collection }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to edit_collection_path, alert: "You can't stop sharing a collection with its owner." }
          format.json { head :no_content }
        end    
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_collection_path, alert: 'This user is not your friend.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:title)
    end
end