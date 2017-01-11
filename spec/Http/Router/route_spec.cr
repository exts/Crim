require "../../spec_helper"

describe Crim::Http::Router::Route do

  it "should raise error on empty route" do
    expect_raises(Crim::Exceptions::EmptyRouteException) do
      route = Crim::Http::Router::Route.new
    end
  end

  it "should raise error on invalid method" do
    expect_raises(Crim::Exceptions::InvalidRouteMethodException) do
      route = Crim::Http::Router::Route.new "/user/:id", "custom_method"
    end
  end

  it "should match route data" do
    route = Crim::Http::Router::Route.new "/user/:id", default: {"id" => "0"}, regex: {"id" => %q(\d+)}
    route.route.should eq("/user/:id")
    route.method.should eq("get")
    route.default_data.should eq({"id" => "0"})
    route.regex_data.should eq({"id" => %q(\d+)})
  end

  describe "#regex" do
    it "should NOT overwrite existing regex key" do
      route = Crim::Http::Router::Route.new "/user/:id", regex: {"id" => %q(\d+)}
      route.regex("id", "\d{4}")
      route.regex_data["id"]?.should eq(%q(\d+))
    end

    it "should NOT overwrite existing default key" do
      route = Crim::Http::Router::Route.new "/user/:id", default: {"id" => "10"}
      route.default("id", "19999999")
      route.default_data["id"]?.should eq("10")
    end

    it "should add new regex key" do
      route = Crim::Http::Router::Route.new "/user/:id[/:username]", regex: {"id" => %q(\d+)}
      route.regex("username", "[A-Za-z0-9_-]+")
      route.regex_data["username"]?.should eq("[A-Za-z0-9_-]+")
    end

    it "should add new default key" do
      route = Crim::Http::Router::Route.new "/user/:id[/:username]"
      route.default("username", "unknown")
      route.default_data["username"]?.should eq("unknown")
    end
  end

  describe "#parsed_route" do
    it "make sure route parser is being set appropriately" do
      route = Crim::Http::Router::Route.new "/user/:id"
      route.parsed_route.should eq(%q(\/user\/(?<id>\w+)))
    end
  end

end