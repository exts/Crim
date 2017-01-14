require "http/server"

module Crim::Http::Handlers
  include Crim::Http::Router

  # `RouteHandler` is used to process our `RouteContainer` in order to
  # attach a path to a action class (or controller).
  #
  # This handler should be called after any log middleware to capture any runtime errors.
  class RouteHandler
    include HTTP::Handler

    def initialize(@container : RouteContainer)
    end

    # Default call method used in http handler
    def call(context : HTTP::Server::Context)
      @container.routes.each do |route|
        action_data = route[:action]?
        current_route = route[:route]?

        # make sure http method matches current route method
        if !current_route.nil? && context.request.method == current_route.method.upcase
          route_context = handle_route(context, current_route, action_data)
          puts route_context
          return route_context if !route_context.nil?
        end
      end

      call_next(context)
    end

    # This method takes the context, current route data & action data (NamedTuple containing an
    # `Crim::Http::Router::Action` and a string method, which can be nil) and attempts to check
    # if our route and method matches the current route and http method then processes our action
    # controller if it successful then processes the rest of the handlers in the array.
    protected def handle_route(context, route, action_data)
      if found = context.request.path.match /^#{route.parsed_route}$/
        action = action_data[:action]?
        controller = parse_controller_params(found, action_data[:controller]?, route)
        context = handle_controller_action(controller, action, context)
        return context
      end

      nil
    end

    # Inner method which assigns our matched action from the action data then attempts to check
    # if our method returns a response or not and we then decide if we need to create a new context
    # using the response data and return the context
    protected def handle_controller_action(controller, action, context)
      # set current route action
      controller.set_current_action(action)

      # set default response type and status code
      context.response.status_code = 200
      context.response.content_type = "text/html"

      # get action response if one and handle the context accordingly
      response = controller.action(context.request, context.response)
      if !response.nil? && response.is_a?(HTTP::Server::Response)
        context = HTTP::Server::Context.new context.request, response
      end

      context
    end

    # This method assigns any matched parameters from the route and then assigns them to the current
    # controller.
    protected def parse_controller_params(matches, controller, route)
      if !route.route_variables.empty?
        route.route_variables.each do |v|
          # get current matched group name if it exists
          var_data = matches.not_nil![v]?

          # set default variable data if set
          controller.params[v] = route.default_data[v]? if !route.default_data[v]?.nil?

          # override default data with matched route variable
          controller.params[v] = var_data if !var_data.nil?
        end
      end
      controller
    end
  end # RouteHandler
end