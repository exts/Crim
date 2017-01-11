module Crim::Http::Router

  class RouteParser

    @default_regex_replacement = %q(\w+)

    getter regex_variables = {} of String => String
    getter matched_variables = [] of String

    def initialize(@route = "", regex = {} of String => String)
      @regex_variables = regex
      extract_variables()
    end

    private def extract_variables
      # reset array so we can't call this multiple times
      @matched_variables = [] of String

      # start the process
      extract_variables(@route)
    end

    # todo: refactor this
    private def extract_variables(find : String)
      if found = find.match /(?:\:([A-Za-z_]+))/
        if !found[1]?.nil?
          @matched_variables << found[1] if !@matched_variables.includes?(found[1])
          if !found.not_nil!.post_match.empty?
            extract_variables(found.post_match)
          end
        end
      end
    end

    def parse
      # replace [] with (?:)? optional groups
      route = @route.gsub("[", "(?:")
      route = route.gsub("]", ")?")
      route = route.gsub("/", %q(\/))

      @matched_variables.each do |mv|
        rex = @regex_variables.fetch(mv, @default_regex_replacement)
        route = route.sub(":" + mv, "(?<" + mv + ">" + rex + ")")
      end

      route
    end
  end #RouteParser

end