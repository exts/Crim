module Crim::Http::Router
  include Crim::Exceptions

  class Route

    getter route
    getter method
    getter route_variables = [] of String

    # used to keep track of route parameter regex & default values
    getter regex_data = {} of String => String
    getter default_data = {} of String => String

    def initialize(
      @route = "", 
      @method = "get", 
      default = {} of String => String, 
      regex = {} of String => String
    )
      #default options
      @regex_data = regex
      @default_data = default

      # clean up
      @route = @route.strip
      @method = @method.downcase.strip

      # check if route is empty and raise an error if true
      if @route.empty?
        raise EmptyRouteException.new("Route %s was left empty")
      end

      if !METHODS.includes?(@method.upcase.strip)
        raise InvalidRouteMethodException.new(sprintf("Method (%s) isn't in the valid methods list: %s", @method, METHODS.join(", ")))
      end

      self
    end

    # used to store regex values for route parser
    def regex(key : String, val : String)
      if !@regex_data.includes?(key)
        @regex_data[key] = val
      end
      
      self
    end

    # used to store default values when an optional value couldn't be found
    def default(key : String, val : String)
      if !@default_data.includes?(key)
        @default_data[key] = val
      end
      
      self
    end

    def parsed_route
      parser = RouteParser.new @route, @regex_data

      # assign route data from parser if it found anything
      @route_variables = parser.matched_variables if !parser.matched_variables.empty?

      # return route regular expressions
      parser.parse
    end
  end #Router

end