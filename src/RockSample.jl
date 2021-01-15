module RockSample

using LinearAlgebra
using POMDPs
using POMDPModelTools
using StaticArrays
using Parameters
using Random
using Compose
using Combinatorics

export
    RockSamplePOMDP,
    RSPos,
    RSState,
    rs_util

const RSPos = SVector{2, Int64}

"""
    RSState{K}
Represents the state in a RockSamplePOMDP problem. 
`K` is an integer representing the number of rocks

# Fields
- `pos::RPos` position of the robot
- `rocks::SVector{K, Bool}` the status of the rocks (false=bad, true=good)
"""
struct RSState{K}
    pos::RSPos 
    rocks::SVector{K, Bool}
end

@with_kw struct RockSamplePOMDP{K} <: POMDP{RSState{K}, Int64, Int64}
    map_size::Tuple{Int64, Int64} = (5,5)
    rocks_positions::SVector{K,RSPos} = @SVector([(1,1), (3,3), (4,4)])
    init_pos::RSPos = (1,1)
    sensor_efficiency::Float64 = 10.0
    bad_rock_penalty::Float64 = -10
    good_rock_reward::Float64 = 10.
    exit_reward::Float64 = 10.
    terminal_state::RSState{K} = RSState(RSPos(-1,-1),
                                         SVector{length(rocks_positions),Bool}(falses(length(rocks_positions))))
    discount_factor::Float64 = 0.95
end

# to handle the case where rocks_positions is not a StaticArray
function RockSamplePOMDP(map_size,
                         rocks_positions,
                         args...
                        )

    k = length(rocks_positions)
    return RockSamplePOMDP{k}(map_size,
                              SVector{k,RSPos}(rocks_positions),
                              args...
                             )
end

POMDPs.isterminal(pomdp::RockSamplePOMDP, s::RSState) = s.pos == pomdp.terminal_state.pos 
POMDPs.discount(pomdp::RockSamplePOMDP) = pomdp.discount_factor

include("states.jl")
include("actions.jl")
include("transition.jl")
include("observations.jl")
include("reward.jl")
include("visualization.jl")
include("util.jl")

end # module
