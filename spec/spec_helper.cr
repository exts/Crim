require "spec"
require "../src/Crim"

# Example Controller Fixture
class ExampleController < Crim::Http::Router::Action
  def action(req, resp) end
end