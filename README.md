# Crim

Crim is a crystal language micro framework inspired by Slim Framework 3 and other micro frameworks from PHP.

I made Crim to learn Crystal and it introduces me to a lot of different features of the language from macros to regular expressions. So far I believe I've used a lot of the crystal language base features in this project and it's been a blast. If you have any feedback or want to contribute please feel free to add a PR, but please remember currently not everything will be accepted as I'd like to dictate and keep this micro framework as minimal as possible.

## Development

Crim is in early stages so please bare with me while I get the base of the project complete before contributing or using this framework.

## Installation

Add the following to your dependencies

    dependencies:
      Crim:
        github: exts/Crim
        tag: 0.1.1

## Example Application

    require "Crim"

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

## Routes & Group Routes

All routes require a route (`String`) and a `NamedTuple(controller: Action, action: String)` when being called. You also have optional parameters `default` and `regex`. Default allows you to force default values for named variables that don't match anything. You'd usually want to use it for optional parameters. The regex parameter allows you to force a named route variable to match your regular expression. So for instance you'd want only numbers for "page" you could do `{"page" => %q(\d+)}`. Currently the default & regex parameters are stored as a `Hash(String, String)`. I'm contemplating changing it to `Hash(String, String | Int32 | Float32)`, for now it seems fine for what we need.

**Example of Group Routes**

    routes = RouteContainer.new
    routes.group "/admin", do |route|
      route.group "/users", do |route|
        route.any "/update/:id", {controller: ExampleController.new, action: "update"}
      end
    end

_(Note: Group routes can be as deep as you want, but I wouldn't recommend it)_

**Example use of default & regex**

    routes = RouteContainer.new
    routes.any "/post/:id[/:page]", {controller: ExampleController.new, action: nil}, default: {"page", "1"}

or

    routes = RouteContainer.new
    routes.any "/post/:id[/:page]", {controller: ExampleController.new, action: nil}, {"id", %q(\d+)}, {"page", "1"}   

## Contributors

- [[exts]](https://github.com/exts) Lamonte - creator, maintainer
