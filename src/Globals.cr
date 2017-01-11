require "http/server"

module Crim
  extend self

  # convert context to json
  def to_json(context)
    context.response.content_type = "application/json"
    context
  end

  # Redirect user to path using the current response
  def redirect(response : HTTP::Server::Response, 
    path : String, status_code : Int32 = 307) : HTTP::Server::Response
    response.headers.add "Location", path
    response.status_code = status_code
    response
  end

end