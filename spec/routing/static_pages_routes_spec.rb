require "spec_helper"

describe "Static pages routes" do
  it "route to home page" do
    { get: "/" }.should route_to(controller: "static_pages", action: "home")
  end

  it "route to about page" do
    { get: "/about" }.should route_to(controller: "static_pages", action: "about")
  end

  it "route to contact page" do
    { get: "/contact" }.should route_to(controller: "static_pages", action: "contact")
  end

  it "route named root path" do
    { get: root_path }.should route_to(controller: "static_pages", action: "home")
  end

  it "route named about path" do
    { get: about_path }.should route_to(controller: "static_pages", action: "about")
  end

  it "route named contact path" do
    { get: contact_path }.should route_to(controller: "static_pages", action: "contact")
  end
end