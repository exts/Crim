# Crim

Crim is a crystal language micro framework inspired by Slim Framework 3 and other micro frameworks from PHP.

I made Crim to learn Crystal and it introduces me to a lot of different features of the language from macros to regular expressions. So far I believe I've used a lot of the crystal language base features in this project and it's been a blast. If you have any feedback or want to contribute please feel free to add a PR, but please remember currently not everything will be accepted as I'd like to dictate and keep this micro framework as minimal as possible.

## Development

Crim is in early stages so please bare with me while I get the base of the project complete before contributing or using this framework.

## Example Application

    require "./src/Crim"
    require "./src/Crim/*"
    require "./src/Crim/Exceptions/*"
    require "./src/Crim/Http/*"
    require "./src/Crim/Http/Router/*"
    require "./src/Crim/Http/Handlers/*"

    include Crim::Http::Handlers
    include Crim::Http::Router

    # Example Action Controller
    class ExampleController < Action
      def action(request, response)
        response.write "hello!, World it works!".to_slice
        response
      end
    end

    routes = RouteContainer.new
    routes.get "/", {controller: ExampleController.new, action: nil}

    app = Crim::Server.new
    app.add_middleware LogHandler.new "example.log"
    app.add_middleware RouteHandler.new routes
    app.run

## Contributors

- [[exts]](https://github.com/exts) Lamonte - creator, maintainer
