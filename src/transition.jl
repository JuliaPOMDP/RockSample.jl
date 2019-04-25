function POMDPs.transition(pomdp::RockSamplePOMDP{K}, s::RSState{K}, a::Int64) where K
    if a < N_BASIC_ACTIONS
        # the robot moves 
        new_pos = s.pos + ACTION_DIRS[a]
    elseif a >= N_BASIC_ACTIONS 
        # robot check rocks or samples
        new_pos = s.pos
    end
    if a == BASIC_ACTIONS_DICT[:sample] && in(s.pos, pomdp.rocks_positions)
        rock_ind = findfirst(isequal(s.pos), pomdp.rocks_positions) # slow ?
        # set the new rock to bad
        new_rocks = MVector{K, Bool}(undef)
        for r=1:K
            new_rocks[r] = r == rock_ind ? false : s.rocks[r]
        end
        new_rocks = SVector(new_rocks)
    else 
        new_rocks = s.rocks
    end
    if new_pos[1] > pomdp.map_size[1]
        # the robot reached the exit area
        new_state = pomdp.terminal_state
    else
        new_pos = RSPos(clamp(new_pos[1], 1, pomdp.map_size[1]), 
                        clamp(new_pos[2], 1, pomdp.map_size[2]))
        new_state = RSState{K}(new_pos, new_rocks)
    end
    return Deterministic(new_state)
end