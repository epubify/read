# -*- coding: utf-8 -*-
require 'restclient'
require 'digest/md5'
require 'json'

module Read
  class Gravatar
    class GravatarException < StandardError; end

    def self.find_by_email email
      self.new(email)
    end

    def self.find_by_nick nick
      self.new(nick)
    end

    def self.find_by_hash h
      self.new(h)
    end

    def self.lookup_hash email
      digest = Digest::MD5.hexdigest(email)
      @gravatar_hash = digest # email hash
    end


    def nick
      preferred_username
    end

    def bio
      about_me
    end



    def initialize email
      if email.include? '@'
        digest = Digest::MD5.hexdigest(email)
        @gravatar_hash = digest # email hash
      else
        @gravatar_profile ||= get_gravatar_profile(email) # nick or hash
        @gravatar_hash = served_hash
      end
    end


    def gravatar_profile
      @gravatar_profile ||= get_gravatar_profile(@gravatar_hash)
    end


    def thumbnail_url
      "http://gravatar.com/avatar/#{@gravatar_hash}.png?d=monsterid"
    end


    def photo_url size
      "http://gravatar.com/avatar/#{@gravatar_hash}.png?size=#{size}"
    end

    def preferred_username
      gravatar_profile && gravatar_profile['preferredUsername']
    end


    def about_me
      gravatar_profile && gravatar_profile['aboutMe']
    end


    def name
      gravatar_profile && gravatar_profile['name']['formatted']
    end


    def served_hash
      gravatar_profile && gravatar_profile['hash']
    end


    def display_name
      gravatar_profile && gravatar_profile['displayName']
    end


    private
    def get_gravatar_profile gravatar_hash
      url = "http://nb.gravatar.com/#{gravatar_hash}.json"
      res = RestClient.get(url)

      case res.code
      when 200 # Net::HTTPOK
        json = JSON.parse(res.body)
        json && json['entry'] && json['entry'][0] || nil
      when 404 #Net::HTTPNotFound
        nil
      else
        raise res.inspect
        raise GravatarException.new("Could not fetch profile from gravatar.com")
      end
    end
  end
end
