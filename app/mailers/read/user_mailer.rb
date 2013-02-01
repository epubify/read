module Read
  class UserMailer < ActionMailer::Base
    default from: Cloudmailin.default_from

    def welcome mail_to, secret_mail
      @mail_to = mail_to
      @secret_mail = secret_mail(@mail_to)
      @mail_from = "#{@secret_mail}"

      mail(:to => @mail_to, :from => @mail_from, :subject => "Din epost-adresse til #{@template.title}")
    end


    def article article
      @mail_to = article.email
      @secret_mail = Cloudmailin.secret_mail(@mail_to)
      @mail_from = "#{@secret_mail}"
      @article = article

      mail(:to => @mail_to, :from => @mail_from, :subject => @article.title)
    end
  end


end
