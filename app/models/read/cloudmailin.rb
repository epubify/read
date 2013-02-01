require 'iconv'
require 'mail'
require 'digest/sha1'

class Cloudmailin
  def self.default_from
    ENV['default_from'] || "from@example.com"
  end


  def self.secret mail_from
    digest = Digest::SHA1.digest(mail_from + ".fdasFDAhfs433fdasFaa_SaLT," + default_from)
    token = Base32::Crockford.encode(digest).downcase[0..6]
    token
  end


  def self.secret_mail mail_from
    s = self.secret mail_from, default_from
    Cloudmailin:default_from.gsub("@", "+#{s}@")
  end


  def self.validate mail_from, mail_to
    s = self.secret(mail_from)
    t = mail_to.split('@')[0].split('+')[-1].strip
    (s || "x").downcase === (t || "y").downcase
  end


  def self.email m
    m.split("<")[-1].split(">")[0].strip
  end


  def validate
    f = Cloudmailin.email(self.from)
    t = Cloudmailin.email(self.to[0])
    f && t && Cloudmailin.validate(f, t) || false
  end


  def secret
    f = Cloudmailin.email(from)
    Cloudmailin.secret(f)
  end


  def secret_mail
    f = Cloudmailin.email(from)
    Cloudmailin.secret_mail(f)
  end


  def initialize message
    @mail = Mail.new(message)
  end


  def to 
    (@mail && @mail.to) || nil
  end


  def from
    (@mail && @mail[:from].decoded) || nil
  end


  def subject
    s = (@mail && @mail.subject) || nil
    if s && s.respond_to?(:encode)
      s.encode("utf-8")
    else
      s
    end
  end


  def text_body
    if(@mail &&  @mail.text_part && @mail.text_part.body)
      m = @mail.text_part.body.decoded
      charset = @mail.text_part.charset
      text = charset ? Iconv.conv("utf-8", charset, m) : m
      (text.respond_to? :force_encoding) ? text.force_encoding("utf-8") : text
    elsif(@mail && @mail.body && @mail.content_type.to_s.include?("text/plain"))
      m = @mail.body.decoded
      charset = @mail.charset
      text = charset ? Iconv.conv("utf-8", charset, m) : m
      (text.respond_to? :force_encoding) ? text.force_encoding("utf-8") : text
    else
      nil
    end
  end
end
