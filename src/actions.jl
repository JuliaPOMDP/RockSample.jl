const N_BASIC_ACTIONS = 5
const BASIC_ACTIONS_DICT = Dict(:sample => 1, 
                                :north => 2, 
                                :east => 3,
                                :south => 4,
                                :west => 5)

const ACTION_DIRS = SVector(Coord(0,0),
                            Coord(0,1),
                            Coord(1,0),
                            Coord(0,-1),
                            Coord(-1,0))

POMDPs.n_actions(pomdp::RockSamplePOMDP{K}) where K = N_BASIC_ACTIONS+K
POMDPs.actions(pomdp::RockSamplePOMDP{K}) where K = 1:N_BASIC_ACTIONS+K

function POMDPs.actions(pomdp::RockSamplePOMDP, s::RSState) 
    if in(s.pos, pomdp.rock_pos) # slow? pomdp.rock_pos is a vec 
        return actions(pomdp)
    else
        # sample not available
        return 2:n_actions(pomdp)
    end
end

