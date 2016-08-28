class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    if current_user.is_admin?
      @tags = Tag.all
    else
      redirect_to root_path
    end  
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    if current_user.is_admin?
      @tag = Tag.new
    else
      redirect_to root_path
    end  
  end

  # GET /tags/1/edit
  def edit
    unless current_user.is_admin?
      redirect_to root_path
    end  
  end

  # POST /tags
  # POST /tags.json
  def create
   if current_user.is_admin?
       @tag = Tag.new(tag_params)
       respond_to do |format|
        if @tag.save
          format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
          format.json { render :show, status: :created, location: @tag }
        else
          format.html { render :new }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end  
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if current_user.is_admin?
      respond_to do |format|
        if @tag.update(tag_params)
          format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
          format.json { render :show, status: :ok, location: @tag }
        else
          format.html { render :edit }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end  
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name)
    end
end
