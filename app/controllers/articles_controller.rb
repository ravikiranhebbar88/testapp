class ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  

  # GET /articles
  # GET /articles.json
  def index
    @articles = current_user.articles
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = current_user.articles.build
    @tags = @article.tags
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @tags = @article.tags
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.build(article_params)
    respond_to do |format|
     if @article.save
       if params[:tags] 
          params[:tags].each do |tag|
            if tag.to_i == 0
                 tag = Tag.create!(name: tag)
                 tag = tag.id
            else
                 tag = tag.to_i
            end 
            ArticleTag.create!(:article_id => @article.id,:tag_id => tag)  
          end 
        end   
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
          format.html { render :new }
          format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end 
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        if params[:tags]
           article_tags = ArticleTag.where.not(tag_id: params[:tags].map(&:to_i))
           if article_tags
             tag_array = []
             article_tags.collect{|a|tag_array << a.tag_id}
             ArticleTag.where(article_id: @article.id,tag_id: tag_array).destroy_all
           end  
           params[:tags].each do |tag|
             if tag.to_i == 0
               tag = Tag.create!(name: tag)
               tag = tag.id
             else
               tag = tag.to_i
             end 
             unless ArticleTag.exists?(:article_id => @article.id,:tag_id => tag)
               ArticleTag.create!(:article_id =>@article.id, :tag_id => tag.to_i)
             end
           end 
        elsif ArticleTag.exists?(article_id: @article.id)
            ArticleTag.where(article_id: @article.id).destroy_all
        end  
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find_by_permalink(params[:id].gsub(/\d+-/,''))
      if @article.nil?
         redirect_to articles_path
      end  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :description,:bootsy_image_gallery_id)
    end
end
