require_dependency "read/application_controller"

module Read
  class ProfileController < ApplicationController
    def show
      email = params[:id];
      @byline = Gravatar.find_by_nick(email)
      @articles = Article.where(:profile_hash => @byline.served_hash).order('created_at DESC').paginate(:page => @page, :per_page => 10)
      @thumbnail = @byline.thumbnail_url
      @email
      
      response.headers['Cache-Control'] = 'public, max-age=15'
      render
    end
  end
end
