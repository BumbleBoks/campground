require "spec_helper"

describe "Corner pages routes" do
  it "route to user favorites show page" do
    { get: "/favorites/show" }.should route_to(controller: "corner/favorites", action: "show")
  end
  
  it "route to user favorites new page" do
    { get: "/favorites/new" }.should route_to(controller: "corner/favorites", action: "new")
  end
  
  it "route to user favorites create page" do
    { post: "/corner/favorites" }.should route_to(controller: "corner/favorites", action: "create")
  end

  it "route to user favorites add trail page" do
    { post: "/corner/favorites/add_trail" }.should route_to(controller: "corner/favorites", 
      action: "add_trail")
  end
  
  it "route to user favorites remove trail page" do
    { post: "/corner/favorites/remove_trail" }.should route_to(controller: "corner/favorites", 
      action: "remove_trail")
  end
  
  it "route to user favorites add star page"do
    { post: "/corner/favorites/add_star"}.should route_to(controller: "corner/favorites", 
      action: "add_star")
  end
  
  it "route to user favorites remove star page"do
    { post: "/corner/favorites/remove_star"}.should route_to(controller: "corner/favorites", 
      action: "remove_star")
  end
  
  it "route named user favorites show page" do
    { get: favorites_show_path }.should route_to(controller: "corner/favorites", action: "show")
  end
  
  it "route named user favorites new page" do
    { get: favorites_show_path }.should route_to(controller: "corner/favorites", action: "show")
  end

  it "route named user favorites create page" do
    { post: corner_favorites_path }.should route_to(controller: "corner/favorites", action: "create")
  end

  it "route named user favorites add trail page" do
    { post: corner_favorites_add_trail_path }.should route_to(controller: "corner/favorites", 
      action: "add_trail")
  end
  
  it "route named user favorites remove trail page" do
    { post: corner_favorites_remove_trail_path }.should route_to(controller: "corner/favorites", 
      action: "remove_trail")
  end

  it "route named user favorites add star page" do
    { post: corner_favorites_add_star_path }.should route_to(controller: "corner/favorites", 
      action: "add_star")
  end
  
  it "route named user favorites remove star page" do
    { post: corner_favorites_remove_star_path }.should route_to(controller: "corner/favorites", 
      action: "remove_star")
  end
  
  it "route to user logs show page" do
    { get: "/corner/logs/2013/1/2" }.should route_to(controller: "corner/logs", action: "show",
      year: "2013", month: "1", day:"2")
  end
  
  # it "route to user logs new page" do
  #   { get: "/corner/logs/new" }.should route_to(controller: "corner/logs", action: "new")
  # end
    
  # it "route to user logs create page" do
  #   { post: "/corner/logs" }.should route_to(controller: "corner/logs", action: "create")
  # end
    
  it "route to user logs edit page" do
    { get: "/corner/logs/2013/1/3/edit" }.should route_to(controller: "corner/logs", action: "edit", 
      year: "2013", month: "1", day: "3")
  end
    
  it "route to user logs update page" do
    { post: "/corner/logs/2013/3/4" }.should route_to(controller: "corner/logs", action: "update", 
      year: "2013", month: "3", day: "4")
  end
    
  it "route to user logs delete page" do
    { delete: "/corner/logs/1"}.should route_to(controller: "corner/logs", action: "destroy", id: "1")
  end
    
  it "route named user logs show page" do
    { get: corner_logs_path(2013,1,2) }.should route_to(controller: "corner/logs", action: "show",
      year: "2013", month: "1", day:"2")
  end
  
  # it "route named user logs new page" do
  #   { get: new_corner_log_path }.should route_to(controller: "corner/logs", action: "new")
  # end

  it "route named user logs edit page" do
    { get: edit_corner_log_path(2013,1,2) }.should route_to(controller: "corner/logs", action: "edit", 
      year: "2013", month: "1", day:"2")
  end
end