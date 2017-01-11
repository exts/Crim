module Crim::Http::Router
  class RouteContainer
    @groups = [] of String

    # getter routes = [] of Route
    getter routes = [] of NamedTuple(route: Route,
    action: NamedTuple(controller: Action, action: String | Nil),
    method: String)

    def add(route : String,
            action : NamedTuple(controller: Action, action: String | Nil),
            method = "get",
            regex = {} of String => String,
            default = {} of String => String)
      new_route = Route.new parse_route(route), method, default, regex
      if !@routes.includes?({route: new_route, action: action, method: method})
        @routes << {route: new_route, action: action, method: method}
      end
    end

    def any(route : String,
            action : NamedTuple(controller: Action, action: String | Nil),
            regex = {} of String => String,
            default = {} of String => String,
            all_methods = false)
      if !all_methods
        self.add route, action, "get", regex, default
        self.add route, action, "post", regex, default
      else
        METHODS.each do |m|
          self.add route, action, m.downcase.strip, regex, default
        end
      end
    end

    {% for method in METHODS %}
      def {{method.id.downcase.strip}}(
        route : String,
        action : NamedTuple(controller: Action, action: String | Nil),
        method = {{method}}.downcase.strip,
        regex = {} of String => String,
        default = {} of String => String
      )
        self.add route, action, method, regex, default
      end
    {% end %}

    # def add(route : String, action: Action, )

    def group(route : String, &closure : RouteContainer -> _)
      @groups << route
      closure.call self
      @groups.pop?
    end

    private def parse_route(route : String)
      # remove trailing forward slash from end of each group before joining
      @groups.map! { |g| g.chomp('/').lchomp('/') }
      group_prefix = @groups.join('/').strip

      # we remove the starting forward slash in case a group prefix exists
      # then readd it back to properly give us a normalized route path
      route = route.lchomp('/')
      route = "#{group_prefix}/#{route}"
      route = "/#{route}" if !group_prefix.empty?
      route
    end
  end
end
