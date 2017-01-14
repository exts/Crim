require "./Globals"
require "./Crim/*"
require "./Crim/Exceptions/*"
require "./Crim/Http/*"
require "./Crim/Http/Router/*"
require "./Crim/Http/Handlers/*"

module Crim
  # This is the main server we use to initialize our framework
  # It's as simple as writing:
  #
  #     app = Crim::Server.new(8080)
  #     app.run()
  #
  # The above will give you the very basic instance of the application
  # *Note you won't be able to do anything with the above without using the
  # `Crim::Http::Handlers::RouteHandler` and providing a container of routes
  # (`Crim::Http::Router::RouteContainer`) to run your application.
  class Server
    property routes = Http::Router::RouteContainer.new

    # private variables
    @log_file = "error.log"
    @middleware = [] of HTTP::Handler

    def initialize(@port : Int32 = 8080, @ip = "127.0.0.1", @public_path = "")
      handle_public_path()
    end

    # Starts the server
    def run
      server = HTTP::Server.new(@ip, @port, @middleware) do |ctx|
        ctx.response.content_type = "text/html"
        # ctx.response.write "testing server".to_slice
        # raise "Testing error handler!"
      end

      puts "Listening to http://#{@ip}:#{@port}"

      server.listen
    end

    # setup application default middleware, if a user wants to set middleware
    # before or after this method they can making it extremely flexible at the end of the day
    def setup
      override_middleware = [] of HTTP::Handler

      # add log handler first as the outer onion layer
      override_middleware << Http::Handlers::LogHandler.new @log_file

      # loop through all middleware and pass it to our override array
      @middleware.each do |middle|
        override_middleware << middle
      end

      # add route handler which should always happen after static file handler checks
      override_middleware << Http::Handlers::RouteHandler.new @routes

      # add static file handler after the route handler
      override_middleware << HTTP::StaticFileHandler.new @public_path

      # reassign our middleware handlers to be passed to the server
      @middleware = override_middleware
    end

    # Adds middleware/handlers to our array as long as we haven't already added it
    def add_middleware(handler : HTTP::Handler)
      if !@middleware.includes?(handler)
        @middleware << handler
      end
    end

    protected def handle_public_path
      if !@public_path.empty? && !Dir.exists?(@public_path)
        raise Exceptions::InvalidPublicPathDirectoryException.new "Public path doesn't exist"
      end
    end
  end # Server

end
