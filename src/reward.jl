function POMDPs.reward(pomdp::RockSamplePOMDP, s::RSState, a::Int64)
    if isterminal(pomdp, s)
        return pomdp.exit_reward
    end

    if a == BASIC_ACTIONS_DICT[:sample] && in(s.pos, pomdp.rocks_positions) # sample 
        rock_ind = findfirst(isequal(s.pos), pomdp.rocks_positions) # slow ?
        return s.rocks[rock_ind] ? pomdp.good_rock_reward : pomdp.bad_rock_penalty 
    end
    return 0.
end

function POMDPs.reward(pomdp::RockSamplePOMDP, s::RSState, a::Int64, sp::RSState)
    return reward(pomdp, sp, a)
end