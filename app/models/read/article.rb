# -*- coding: utf-8 -*-
require 'bluecloth'
require 'digest/md5'
require 'uuidtools'
require 'typedown'
require 'cgi'


module Read
  class Article < ActiveRecord::Base
    set_primary_key :token

    attr_accessible :body, :email, :leadin, :path, :title, :token
    attr_accessor :seed

    before_save :calc_profile_hash

    def profile
      @profile ||= Gravatar.find_by_nick(self.profile_hash)
    end

    def byline
      self.profile.display_name
    rescue
      nil
    end


    def byline_bio
      self.profile.about_me
    rescue
      ""
    end


    def static_page?
      false
    end


    def calc_profile_hash
      self.profile_hash = Gravatar.lookup_hash email.downcase
      self
    end


    def reset_token
      self.token = random
      self
    end


    def reset_path
      t = self.title && self.title.tr("æøåÆØÅ", "eoaEOA").gsub(/[^0-9A-Za-z\ \-]/, '').gsub(" ", "-").downcase || ""
      self.path = Time.now.strftime("%Y/%W/#{t}/#{random[0..5]}")
      self
    end


    def leadin_as_html
      Typedown::Document.new(self.leadin).to_html.html_safe
    end


    def body_as_html
      Typedown::Document.new(self.body).to_html.html_safe
    end


    def words
      s = ""
      s << leadin.dup if leadin
      s << " "
      s << body.dup if body 
      s.gsub!(/\w+/, 'X')
      s.gsub!(/[^X]/, '')
      s.length
    end


    def typedown= v
      doc = Typedown::Section.sectionize(v)
      self.title = doc.title
    
      found = false
      self.leadin = ""
      self.body = ""
      doc.body.to_s.strip.lines.each do |line|
        unless found
          if line.strip.length == 0
            found = true
            next
          end
          self.leadin << line.strip
          self.leadin << " "
        else
          self.body << line
        end
      end
      self.leadin.strip!
      self.leadin.gsub!('//.', '')
      self.body.gsub!(/^(!+ )/, '!\0')
      self.body.strip!
    end


    private
    def random
      # Allow seed for predictable path generation on create + delete + create
      random = if(seed)
                 Digest::SHA1.digest(seed + ".fdasFDAhfs4332daafdsFaa_SaLT,")
               else
                 UUIDTools::UUID.random_create.raw
               end

      random = Base32::Crockford.encode(random).downcase
      random
    end

  end
end
