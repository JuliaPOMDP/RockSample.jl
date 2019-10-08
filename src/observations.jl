const OBSERVATION_NAME = (:good, :bad, :none)

POMDPs.observations(pomdp::RockSamplePOMDP) = 1:3
POMDPs.obsindex(pomdp::RockSamplePOMDP, o::Int64) = o

function POMDPs.observation(pomdp::RockSamplePOMDP, a::Int64, s::RSState)
    if a <= N_BASIC_ACTIONS
        # no obs
        return SparseCat((1,2,3), (0.0,0.0,1.0)) # for type stability
    else
        rock_ind = a - N_BASIC_ACTIONS 
        rock_pos = pomdp.rocks_positions[rock_ind]
        dist = norm(rock_pos - s.pos)
        efficiency = 0.5*(1.0 + exp(-dist/pomdp.sensor_efficiency))
        rock_state = s.rocks[rock_ind]
        if rock_state
            return SparseCat((1,2,3), (efficiency, 1.0 - efficiency, 0.0))
        else
            return SparseCat((1,2,3), (1.0 - efficiency, efficiency, 0.0))
        end
    end
end