function POMDPs.observation(pomdp::RockSamplePOMDP, a::Int64, s::RSState)
    if a < N_BASIC_ACTIONS
        # no obs
        return Deterministic(3)
    else
        rock_ind = a - N_BASIC_ACTIONS 
        rock_pos = pomdp.rock_pos[rock_ind]
        dist = norm(rock_pos - s.pos)
        efficiency = 0.5*(1.0 + exp(-dist/pomdp.sensor_efficiency))
        return SparseCat(SVector(1,2), SVector(efficiency, 1.0-efficiency))
    end
end