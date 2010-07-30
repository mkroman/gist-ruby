require 'net/http'
require 'json'

class Gist
  
  attr_accessor :id, :name, :content, :private, :url
  
  CreateURL = "http://gist.github.com/api/v1/json/new"

  def initialize name = nil, content = nil, private = false
    @name    = name
    @private = private
    @content = content
  end
  
  def self.create *arguments
    new(*arguments).publish
  end
  
  def self.credentials user, token
    @@credentials = [user, token]
  end
  
  def private?
    @private == true
  end
  
  def publish
    if response = Net::HTTP.post_form(URI.parse(CreateURL), data)
      result = JSON.parse(response.body)
      if id = result['gists'][0]['repo']
        @id, @url = id, "http://gist.github.com/#{id}"
      else
        raise "Could not publish gist"
      end
    end
    
    self
  end
  
private
  def data
    { "files[#{@name}]" => @content, "private" => private? }.merge auth
  end
  
  def auth
    if Gist.class_variable_defined? :@@credentials
      { 'login' => @@credentials[0], 'token' => @@credentials[1] }
    else
      { 'login' => config("github.user"), 'token' => config("github.token") }
    end
  end
  
  def config key
    %x{git config --global #{key}}.strip
  end
end
