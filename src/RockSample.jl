module RockSample

using POMDPs
using POMDPModelTools
using StaticArrays
using Parameters
using Random

export
    RockSamplePOMDP,
    RSPos,
    RSState

const RSPos = SVector{2, Int}

struct RSState{K}
    pos::RSPos 
    rocks::SVector{K, Bool}
end

@with_kw struct RockSamplePOMDP{K} <: POMDP{RSState{K}, Int64, Int64}
    map_size::Int64 = 5
    n_rocks::Int64 = K
    rocks_positions::Vector{RSPos} = [(1,1), (3,3), (4,4)]
    init_pos::RSPos = (1,1)
    sensor_efficiency::Float64 = 10.0
    bad_rock_penalty::Float64 = -10
    good_rock_reward::Float64 = 10.
    exit_reward::Float64 = 10.
    discount_factor::Float64 = 0.95
end

RockSamplePOMDP(;n_rocks::Int64=3, kwargs...) = RockSamplePOMDP{n_rocks}(;kwargs...)

terminal_state(pomdp::RockSamplePOMDP{K}) where K = RSState{K}(RSPos(-1,-1), SVector{K, Bool}([false for i=1:K]))

POMDPs.terminal_state(pomdp::RockSamplePOMDP, s::RSState) = s.pos == terminal_state.pos 
POMDPs.discount(pomdp::RockSamplePOMDP) = pomdp.discount_factor

include("states.jl")
include("actions.jl")
include("transition.jl")
include("observations.jl")
include("obs_model.jl")
include("reward.jl")

end # module
