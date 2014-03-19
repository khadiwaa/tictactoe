require 'socket'

class Server
  def initialize( port = 8000 )
    @port = port
    @server = TCPServer.open port
    @router = Router.new
    @root_path = File.dirname( File.dirname(__FILE__) )
    puts "Listening on port #{port}\r\n"
  rescue Errno::EACCES
    puts "The requested port (#{port}) is not available"
    exit( 1 )
  end

  def start
    loop do
      begin
        client = @server.accept
        request = _create_request_object( client )
        puts "Handling request: #{request.path}\r\n"
        unless response = _get_static_file( request )
          response = @router.dispatch( request )
        end

        client.puts response.get_headers
        client.puts response.body
        client.close
      rescue Interrupt
        puts ''
        puts 'Ctrl-C received. Server interrupted. Exiting...'
        return
      end
    end
  end

  private

  def _get_static_file_path( request )
    @root_path + '/public' + request.path.to_s
  end

  def _is_static_file( request )
    File.file?( _get_static_file_path( request ) ) && File.readable?( _get_static_file_path( request ) )
  end

  def _get_static_file( request )
    return false unless _is_static_file( request)
    response = Response.new
    path = _get_static_file_path( request )
    response.type = Util::mime_type( File.extname( path ) )
    response.body = File.read( path )
    response
  end

  def _create_request_object( client )
    request = Request.new
    while line = client.gets
      break if line.to_s.strip.length == 0
      if request.path.nil?
        parts = line.split( ' ' )
        request.verb = parts[0].to_s
        request.path = parts[1].to_s
      else
        h = line.split( ': ', 2 )
        request.headers[ h[0].to_sym ] = h[1]
      end
    end

    if request.verb == 'POST'
      request.data = client.read( request.headers['Content-Length'.to_sym].to_i )
      puts "POST: #{request.data}"
    end

    request
  end
end
