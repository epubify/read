require_dependency "read/application_controller"

module Read
  class HomeController < ApplicationController
    # GET /articles
    # GET /articles.json
    def index
      @articles = Article.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @articles }
      end
    end

    def show
      @article = Article.find_by_path(params[:id])
      respond_to do |format|
        format.html {
          if @article
            response.headers['Cache-Control'] = 'public, max-age=15'
            render :show
          else
            redirect_to("/")
          end
        } # show.html.erb
      end
    end

  end
end
