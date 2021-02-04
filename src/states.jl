function POMDPs.stateindex(pomdp::RockSamplePOMDP{K}, s::RSState{K}) where K
    if isterminal(pomdp, s)
        return length(pomdp)
    end
    return s.pos[1] + pomdp.indices[1] * (s.pos[2]-1) + dot(view(pomdp.indices, 2:(K+1)), s.rocks)
end

function state_from_index(pomdp::RockSamplePOMDP{K}, si::Int) where K
    if si == length(pomdp)
        return pomdp.terminal_state
    end
    rocks_dim = fill(2, K)
    nx, ny = pomdp.map_size
    s = CartesianIndices((nx, ny, rocks_dim...))[si]
    pos = RSPos(s[1], s[2])
    rocks = SVector{K, Bool}([(s[i] - 1) for i=3:K+2])
    return RSState{K}(pos, rocks)
end

# the state space is the pomdp itself
POMDPs.states(pomdp::RockSamplePOMDP) = pomdp

Base.length(pomdp::RockSamplePOMDP) = pomdp.map_size[1]*pomdp.map_size[2]*2^length(pomdp.rocks_positions) + 1

# we define an iterator over it 
function Base.iterate(pomdp::RockSamplePOMDP, i::Int=1)
    if i > length(pomdp)
        return nothing
    end
    s = state_from_index(pomdp, i)
    return (s, i+1)
end

function POMDPs.initialstate(pomdp::RockSamplePOMDP{K}) where K 
    probs = normalize!(ones(2^K), 1)
    states = Vector{RSState{K}}(undef, 2^K)
    for (i,rocks) in enumerate(Iterators.product(ntuple(x->[false, true], K)...))
        states[i] = RSState{K}(pomdp.init_pos, SVector(rocks))
    end
    return SparseCat(states, probs)
end
