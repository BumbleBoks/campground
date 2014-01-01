require "spec_helper"

describe "Site pages routes" do
  it "route to user requests create page" do
    { post: "/site/user_requests" }.should route_to(controller: "site/user_requests", 
      action: "create")
  end

  it "route to edit user requests page" do
    { get: "/site/user_requests/1" }.should route_to(controller: "site/user_requests", 
      action: "edit_request", token: "1")
  end
  
  it "route to process user requests page" do
    { post: "/site/user_requests/1" }.should route_to(controller: "site/user_requests", 
      action: "process_request", token: "1")
  end
  
  it "route named user requests create page" do
    { post: site_user_requests_path }.should route_to(controller: "site/user_requests", 
      action: "create")
  end

  it "route named edit user requests page" do
    { get: edit_site_user_request_path(1) }.should route_to(controller: "site/user_requests", 
      action: "edit_request", token: "1")
  end
  
  it "route named process user requests page" do
    { post: edit_site_user_request_path(1) }.should route_to(controller: "site/user_requests", 
      action: "process_request", token: "1")
  end
end