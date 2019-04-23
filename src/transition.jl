function POMDPs.transition(pomdp::RockSamplePOMDP{K}, s::RSState{K}, a::Int64) where K
    if a < N_BASIC_ACTIONS
        # the robot moves 
        new_pos = s.pos + ACTION_DIRS[a]
    elseif a >= N_BASIC_ACTIONS 
        # robot check rocks or samples
        new_pos = clamp.(s.pos + ACTIONS_DIRS[end], 1, pomdp.map_size)
    end
    return RSState{K}(new_pos, s.rocks)
end