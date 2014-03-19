Dir.glob( File.dirname(__FILE__) + '/lib/*' ).each{ |file|
  require file
}

port = ARGV[0].nil? || ARGV[0].to_i <= 0 ? 8000 : ARGV[0].to_i

server = Server.new( port )
server.start