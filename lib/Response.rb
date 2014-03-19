require 'time'

class Response
  attr_accessor :status, :body, :type

  def initialize
    @status = 200
    @body = nil
    @type = 'text/html'
  end

  def get_headers
    [ _get_status,
       "Date: #{Time.now.httpdate}",
       'Server: TicTacToe',
       "Content-Type: #{@type}; charset=iso-8859-1",
       "Content-Length: #{@body.length}"].join("\r\n") + "\r\n\r\n"
  end

  private

  def _get_status
    case @status
      when 200
        'HTTP/1.1 200 OK'
      when 404
        'HTTP/1.1 404 NOT FOUND'
      when 500
        'HTTP/1.1 500 INTERNAL SERVER ERROR'
    end
  end
end