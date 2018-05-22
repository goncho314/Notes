class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @notes = Note.all
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
    @notes = Note.all
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    @collection.owner = User.find_by username: session[:user]
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def addnote
    @collection = Collection.find_by id: params[:id]
    notes = @collection.note_ids
    notes.push(params[:n_id].to_i)
    @collection.note_ids = notes
    @note = Note.find_by id: params[:n_id]    
    collections = @note.collection_ids
    collections.push(params[:id].to_i)
    @note.collection_ids = collections
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      end
    end
  end

  def removenote
    @collection = Collection.find_by id: params[:id]
    notes = @collection.note_ids
    notes.delete(params[:n_id].to_i)
    @collection.note_ids = notes
    @note = Note.find_by id: params[:n_id]    
    collections = @note.collection_ids
    collections.delete(params[:id].to_i)
    @note.collection_ids = collections
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :edit, status: :ok, location: @collection }
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