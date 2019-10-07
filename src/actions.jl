const N_BASIC_ACTIONS = 5
const BASIC_ACTIONS_DICT = Dict(:north => 1, 
                                :east => 2,
                                :south => 3,
                                :west => 4,
                                :sample => 5)

const ACTION_DIRS = (RSPos(0,1),
                    RSPos(1,0),
                    RSPos(0,-1),
                    RSPos(-1,0),
                    RSPos(0,0))

POMDPs.actions(pomdp::RockSamplePOMDP{K}) where K = 1:N_BASIC_ACTIONS+K
POMDPs.actionindex(pomdp::RockSamplePOMDP, a::Int64) = a

function POMDPs.actions(pomdp::RockSamplePOMDP{K}, s::RSState) where K
    if in(s.pos, pomdp.rocks_positions) # slow? pomdp.rock_pos is a vec 
        return actions(pomdp)
    else
        # sample not available
        return 2:N_BASIC_ACTIONS+K
    end
end

