# -*- coding: utf-8 -*-
require 'bluecloth'
require 'digest/md5'
require 'uuidtools'
require 'typedown'
require 'cgi'


module Read
  class Article < ActiveRecord::Base
    attr_accessible :body, :email, :leadin, :path, :title, :token
    attr_accessor :seed


    def byline
      self.email
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
