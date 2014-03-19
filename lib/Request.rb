require 'uri'

class Request
  attr_accessor :headers, :path, :verb, :data

  def initialize
    @headers = {}
    @data = {}
  end

  def get_controller_class
    url_parts = _url_parts
    if @path == '/' || @path.nil?
      return IndexController.new
    elsif url_parts[0] == 'TicTacToe'
      return TicTacToeController.new
    end
    nil
  end

  def get_action_name
    url_parts = _url_parts
    url_parts.length > 1 ? url_parts[1] : 'index'
  end

  def data=( value )
    value.split( '&' ).each do |v|
      parts = v.split( '=', 2 )
      if parts.length == 2
        data[parts[0]] = URI.unescape( parts[1] )
      end
    end
  end

  private
  def _url_parts
    @path.to_s.gsub( /^\//, '' ).split( '/' )
  end
end