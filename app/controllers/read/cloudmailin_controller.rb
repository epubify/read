
require 'mail'
require 'digest/md5'
require 'base32_pure'


module Read
  class CloudmailinController < ApplicationController
    skip_before_filter :verify_authenticity_token


    def index
      render :text => 'ok', :status => 200
    end


    def create
      cm = Cloudmailin.new params[:message]

      mfrom = cm.from
      msubject = cm.subject
      mto = cm.to[0]
      Rails.logger.log Logger::INFO, mfrom
      Rails.logger.log Logger::INFO, msubject
      #Rails.logger.log Logger::INFO, params[:plain]

      unless cm.validate
        if mto.include? Cloudmailin:default_from
          UserMailer.welcome(mfrom, cm.secret_mail).deliver
          render :text => 'success', :status => 200
        else
          render :text => 'non-matching email address', :status => 404 # :unprocessable_entity
        end
        return
      end

      mbody = cm.text_body || params[:plain] || ""
      mbody.strip!


      # Make sure subject doesn't start with '! '
      msubject.gsub!(/^\!\ /, '')
      typedown = ""
      # Add subject as title unless title already exists in body
      typedown << ("! " + msubject + "\n\n") unless(mbody[0..1] === '! ')

      # Add body
      typedown << mbody

      @article = Article.new

      # Content fields
      @article.typedown = typedown
      @article.email = mfrom.split("<")[-1].split(">")[0].strip

      # Autofields
      @article.reset_token
      @article.reset_path

      if @article.save
        UserMailer.article(@article).deliver
        render :text => 'success', :status => 200 # a status of 404 would reject the mail
      else
        render :xml => @article.errors, :status => 404 # :unprocessable_entity
      end
    end
  end
end
