
module Crim::Http::Router

  abstract class Action
    # Used to keep track of the current matched route variables
    # and the value that was passed to the route so you can easily
    # grab it from the url and parse it.
    property params = {} of String => String | Nil

    # Used to check current action for controllers that want to use multiple
    # actions in a single controller. Then you'd do:
    # 
    #     def action(request, response)
    #       case current_action
    #       when "index"
    #         index(request, response)
    #       when "update"
    #         update(request, response)
    #       end
    #     end
    #
    #  This allows you to handle many actions per controller if needed
    getter current_action = ""

    # abstract method which takes server response/request data w/ the 
    # option to return a response
    abstract def action(request : HTTP::Request, 
      response : HTTP::Server::Response) : HTTP::Server::Response | Nil

    # set current current_action
    def set_current_action(current_action : String | Nil = nil)
      @current_action = current_action
    end
  end

end