require "http/server"

module Crim::Http::Handlers

  # Used to catch runtime errors from our controller actions and log them
  # TODO: Finish this handler
  class LogHandler
    include HTTP::Handler
    
    def initialize(@file : String, @io : IO = STDOUT) end

    # Todo, log errors to a file
    def call(context : HTTP::Server::Context)
      begin
        call_next(context)
      rescue ex : Exception
        @io.puts ex.message
        context.response.respond_with_error("Internal Server Error", 500)
        # context.response.respond_with_error("{error: \"Internal Server Error\"}", 500)
        # App.to_json(context)
      end
    end
  end
  
end