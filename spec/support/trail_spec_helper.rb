def create_trail
  state = FactoryGirl.create(:state) 
  FactoryGirl.create(:trail, state_id: state.id) 
end

def trail_link(trail)
  trail.name + ", " + trail.state.name
end