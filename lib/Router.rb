class Router
  def dispatch( request )
    method = request.get_action_name
    controller = request.get_controller_class

    return _get_404_response if controller.nil? || !controller.respond_to?( method )

    controller.request = request
    controller.send method
    controller.response
  rescue Exception => e
    puts "Exception: #{e.message}"
    puts 'Backtrace:'
    e.backtrace.each do |step|
      puts "    #{step}"
    end
    _get_500_response
  end

  def _get_500_response
    puts '500 - Internal server error'
    r = Response.new
    r.status = 500
    r.body = 'Internal Server Error'
    r
  end

  def _get_404_response
    puts '404 - Page not found'
    r = Response.new
    r.status = 404
    r.body = 'The requested page could not be found'
    r
  end
end