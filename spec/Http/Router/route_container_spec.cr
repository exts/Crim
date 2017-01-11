require "../../spec_helper"

describe Crim::Http::Router::RouteContainer do
  
  describe "#add" do
    it "should add route to array of named tuples" do
      container = Crim::Http::Router::RouteContainer.new
      container.add "/example", {controller: ExampleController.new, action: nil}
      container.routes[0][:route].route.should eq("/example")
    end
  end

  describe "#get & post" do
    it "should add get route using our macro generated methods" do
      container = Crim::Http::Router::RouteContainer.new
      container.get "/example", {controller: ExampleController.new, action: nil}
      container.routes[0][:route].route.should eq("/example")
      container.routes[0][:route].method.should eq("get")
    end

    it "should add post route using our macro generated methods" do
      container = Crim::Http::Router::RouteContainer.new
      container.post "/example", {controller: ExampleController.new, action: nil}
      container.routes[0][:route].route.should eq("/example")
      container.routes[0][:route].method.should eq("post")
    end
  end

  describe "#any" do
    it "should add two routes get/post by default" do
      container = Crim::Http::Router::RouteContainer.new
      container.any "/example", {controller: ExampleController.new, action: nil}
      container.routes[0][:route].route.should eq("/example")
      container.routes[0][:route].method.should eq("get")
      container.routes[1][:route].route.should eq("/example")
      container.routes[1][:route].method.should eq("post")
    end
  end

  describe "#group" do
    it "should add route when doing multiple sub groups" do
      container = Crim::Http::Router::RouteContainer.new
      container.group "/admin", do |router|
        router.group "/users", do |router|
          router.add "/update", {controller: ExampleController.new, action: nil}
        end
      end
      container.routes[0][:route].route.should eq("/admin/users/update")
    end
  end

end