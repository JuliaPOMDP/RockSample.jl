function POMDPs.transition(pomdp::RockSamplePOMDP{K}, s::RSState{K}, a::Int64) where K
    if a < N_BASIC_ACTIONS
        # the robot moves 
        new_pos = s.pos + ACTION_DIRS[a]
    elseif a >= N_BASIC_ACTIONS 
        # robot check rocks or samples
        new_pos = s.pos
    end
    if new_pos[1] > pomdp.map_size[1]
        # the robot reached the exit area
        new_state = pomdp.terminal_state
    else
        new_pos = RSPos(clamp(new_pos[1], 1, pomdp.map_size[1]), 
                        clamp(new_pos[2], 1, pomdp.map_size[2]))
        new_state = RSState{K}(new_pos, s.rocks)
    end
    return Deterministic(new_state)
end