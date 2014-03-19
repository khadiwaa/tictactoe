require 'json'

class BaseController
  attr_accessor :response, :request

  def initialize
    @response = Response.new
    @request = nil
  end

  def set_html_view( file )
    views_directory = File.dirname( File.dirname(__FILE__) ) + '/views/' + self.class.name.gsub( /Controller/, '' ).downcase
    path = views_directory + '/' + request.path.to_s + '/' + file
    if File.readable?( path )
      @response.body = File.read( path )
    end
  end

  def respond_with_json( data )
    @response.type = 'text/json'
    @response.body = JSON.generate( data, quirks_mode: true)
  end
end