require "../../spec_helper"

describe Crim::Http::Router::RouteParser do
  describe "#parse" do

    it "should extract named variable from route" do
      parser = Crim::Http::Router::RouteParser.new "/user/:id"
      parser.matched_variables.should contain("id")
    end

    it "should extract underscore named variable from route" do
      parser = Crim::Http::Router::RouteParser.new "/user/:user_id"
      parser.matched_variables.should contain("user_id")
    end

    it "parse named route returns matching regex" do
      parser = Crim::Http::Router::RouteParser.new "/user/:id"
      parsed = parser.parse
      parsed.should eq(%q(\/user\/(?<id>\w+)))
    end

    it "parse named route with custom regex which returns matching regex" do
      parser = Crim::Http::Router::RouteParser.new "/user/:id", {"id" => %q(\d+)}
      parsed = parser.parse
      parsed.should eq(%q(\/user\/(?<id>\d+)))
    end
    
  end
end