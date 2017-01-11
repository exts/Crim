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

    @middleware = [] of HTTP::Handler
    
    def initialize(@port : Int32 = 8080, @ip = "127.0.0.1") end

    # Starts the server
    def run()
      server = HTTP::Server.new(@ip, @port, @middleware) do |ctx|
        ctx.response.content_type = "text/html"
        # ctx.response.write "testing server".to_slice
        # raise "Testing error handler!"
      end

      puts "Listening to http://#{@ip}:#{@port}"

      server.listen
    end

    # Adds middleware/handlers to our array as long as we haven't already added it
    def add_middleware(handler : HTTP::Handler)
      if !@middleware.includes?(handler)
        @middleware << handler
      end
    end
  end # Server

end
