function POMDPs.reward(pomdp::RockSamplePOMDP, s::RSState, a::Int64, sp::RSState)
    if isterminal(pomdp, sp)
        return pomdp.exit_reward
    end

    if a == 1 && in(s.pos, pomdp.rocks_positions) # sample 
        rock_ind = findfirst(s.pos, pomdp.rocks_position) # slow
        return s.rocks[rock_ind] ? pomdp.good_rock_reward : pomdp.bad_rock_penalty 
    end
    return 0.
end