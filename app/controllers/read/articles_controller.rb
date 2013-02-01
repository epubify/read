require_dependency "read/application_controller"

module Read
  class ArticlesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_filter :authenticate, :only => [ :index, :create, :new ]


    # GET /articles
    # GET /articles.json
    def index
      @articles = Article.all
      @javascript = true
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @articles }
      end
    end

    # GET /articles/1
    # GET /articles/1.json
    def show
      @article = Article.find(params[:id])
      @javascript = true
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @article }
      end
    end

    # GET /articles/new
    # GET /articles/new.json
    def new
      @article = Article.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @article }
      end
    end
  
    # GET /articles/1/edit
    def edit
      @article = Article.find(params[:id])
    end
  
    # POST /articles
    # POST /articles.json
    def create
      @article = Article.new(params[:article])
      @article.reset_token
      @article.reset_path
      @article.calc_profile_hash
  
      respond_to do |format|
        if @article.save
          format.html { redirect_to @article, notice: 'Innlegget ble opprettet.' }
          format.json { render json: @article, status: :created, location: @article }
        else
          format.html { render action: "new" }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /articles/1
    # PUT /articles/1.json
    def update
      @article = Article.find(params[:id])
  
      respond_to do |format|
        if @article.update_attributes(params[:article])
          @article.calc_profile_hash
          format.html { redirect_to @article, notice: 'Article was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /articles/1
    # DELETE /articles/1.json
    def destroy
      @article = Article.find(params[:id])
      @article.destroy
  
      respond_to do |format|
        format.html { redirect_to articles_url }
        format.json { head :no_content }
      end
    end


private
    def authenticate
      user_id, password = ENV['ADMIN_USER'] || "admin", ENV['ADMIN_PASSWORD'] || "kueR10"
      authenticate_or_request_with_http_basic do |id, password| 
        id == user_id && password == password
      end
    end

  end
end
