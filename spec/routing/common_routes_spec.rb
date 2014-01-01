require "spec_helper"

describe "Common pages routes" do
  it "route to trails index page" do
    { get: "/common/trails" }.should route_to(controller: "common/trails", action: "index")
  end

  it "route to new trails page" do
    { get: "/common/trails/new" }.should route_to(controller: "common/trails", action: "new")
  end

  it "route to edit trail page" do
    { get: "/common/trails/abc/edit" }.should route_to(controller: "common/trails", action: "edit", id: "abc")
  end

  it "route to show trail page" do
    { get: "/common/trails/def" }.should route_to(controller: "common/trails", action: "show", id: "def")
  end

  it "route to trails create page" do
    { post: "/common/trails" }.should route_to(controller: "common/trails", action: "create")
  end

  it "route to trails update page" do
    { patch: "/common/trails/ghi" }.should route_to(controller: "common/trails", action: "update", id: "ghi")
  end

  it "route to search trails page" do
    { get: "/common/trails/search/abc" }.should route_to(controller: "common/trails", action: "search",
      name: "abc")
  end

  it "route named trails index page" do
    { get: common_trails_path }.should route_to(controller: "common/trails", action: "index")
  end

  it "route named new trails page" do
    { get: new_common_trail_path }.should route_to(controller: "common/trails", action: "new")
  end

  it "route named edit trail page" do
    { get: edit_common_trail_path("xyz") }.should route_to(controller: "common/trails", action: "edit", id: "xyz")
  end

  it "route named trails search page" do
    { get: search_common_trails_path("xyz") }.should route_to(controller: "common/trails", action: "search",
      name: "xyz")
  end

  it "route to missing trails index page" do
    { get: "/common/missing_trails" }.should route_to(controller: "common/missing_trails", action: "index")
  end

  it "route to edit missing trail page" do
    { get: "/common/missing_trails/1/edit" }.should route_to(controller: "common/missing_trails", 
      action: "edit", id: "1")
  end

  it "route to missing trails create page" do
    { post: "/common/missing_trails" }.should route_to(controller: "common/missing_trails", action: "create")
  end

  it "route to missing trails update page" do
    { patch: "/common/missing_trails/1" }.should route_to(controller: "common/missing_trails", 
      action: "update", id: "1")
  end

  it "route named missing trails index page" do
    { get: common_missing_trails_path }.should route_to(controller: "common/missing_trails", action: "index")
  end

  it "route named edit missing trail page" do
    { get: edit_common_missing_trail_path(1) }.should route_to(controller: "common/missing_trails", 
      action: "edit", id: "1")
  end

end