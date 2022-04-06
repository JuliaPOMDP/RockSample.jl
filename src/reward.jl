function POMDPs.reward(pomdp::RockSamplePOMDP, s::RSState, a::Int)
    r = pomdp.step_penalty
    if next_position(s, a)[1] > pomdp.map_size[1]
        r += pomdp.exit_reward
        return r
    end

    if a == BASIC_ACTIONS_DICT[:sample] && in(s.pos, pomdp.rocks_positions) # sample 
        rock_ind = findfirst(isequal(s.pos), pomdp.rocks_positions) # slow ?
        r += s.rocks[rock_ind] ? pomdp.good_rock_reward : pomdp.bad_rock_penalty 
    elseif a > N_BASIC_ACTIONS # using senssor
        r += pomdp.sensor_use_penalty
    end
    return r
end